"""Teste uniquement le générateur fstab isolé, sans exécuter disk_setup.sh."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts/disk_setup.sh"
GENERATOR = SCRIPT.read_text().split("<<'PY'\n", 1)[1].split("\nPY\n", 1)[0]
UUIDS = [f"12345678-1234-1234-1234-{i:012d}" for i in range(4)]
DEVICES = [f"/dev/fictional-disk-{i}" for i in range(4)]
LABELS = ["Mes photos", "Archives", "Videos", "Sauvegardes"]


class FstabGenerationTests(unittest.TestCase):
    def generate(self, original):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "fstab"
            dest = Path(directory) / "candidate"
            source.write_text(original)
            result = subprocess.run(
                [sys.executable, "-c", GENERATOR, str(source), str(dest),
                 *UUIDS, *DEVICES, *LABELS], capture_output=True, text=True,
            )
            self.assertEqual(source.read_text(), original)
            return result, dest.read_text() if dest.exists() else ""

    def test_preserves_system_entries_and_escapes_spaces(self):
        original = "# configuration\nUUID=system / ext4 defaults 0 1\n"
        result, content = self.generate(original)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(content.startswith(original))
        self.assertIn(r"/mnt/Mes\040photos ext4", content)
        self.assertEqual(sum(line.startswith("UUID=") for line in content.splitlines()), 5)

    def test_replaces_existing_uuid_and_device_entries(self):
        original = (f"UUID={UUIDS[0]} /media/ancien ext4 defaults 0 2\n"
                    f"{DEVICES[1]} /mnt/archive ext4 defaults 0 2\n")
        result, content = self.generate(original)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sum(line.startswith("UUID=") for line in content.splitlines()), 4)
        self.assertIn("# Ancienne entrée sauvegardée", content)

    def test_refuses_selected_system_partition(self):
        result, content = self.generate(f"UUID={UUIDS[0]} /home ext4 defaults 0 2\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(content, "")

    def test_refuses_target_conflict(self):
        result, _ = self.generate("UUID=other /mnt/Archives ext4 defaults 0 2\n")
        self.assertNotEqual(result.returncode, 0)

    def test_refuses_nested_and_bind_mounts(self):
        for entry in ["UUID=other /mnt/Archives/nested ext4 defaults 0 2\n",
                      "/mnt/Archives/folder /somewhere none bind 0 0\n"]:
            with self.subTest(entry=entry):
                result, _ = self.generate(entry)
                self.assertNotEqual(result.returncode, 0)

    def test_refuses_malformed_fstab(self):
        result, _ = self.generate("unfinished entry\n")
        self.assertNotEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()
