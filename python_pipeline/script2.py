from pathlib import Path

import SimpleITK as sitk
import numpy as np
from skimage import measure
import trimesh


DICOM_DIR = "C:/Users/Marcepano/Desktop/imhotep-vr-biomed/data/raw_dicom/ID00422637202311677017371"
OUT_OBJ = Path("chest_model.obj")

THRESHOLD_HU = 300


def load_dicom_series(dicom_dir: Path):
    reader = sitk.ImageSeriesReader()

    series_ids = reader.GetGDCMSeriesIDs(str(dicom_dir))
    if not series_ids:
        raise RuntimeError(f"Nie znaleziono serii DICOM w folderze: {dicom_dir}")

    series_files = reader.GetGDCMSeriesFileNames(str(dicom_dir), series_ids[0])
    reader.SetFileNames(series_files)

    image = reader.Execute()

    volume = sitk.GetArrayFromImage(image).astype(np.float32)

    spacing_xyz = image.GetSpacing()  # x, y, z
    spacing_zyx = (spacing_xyz[2], spacing_xyz[1], spacing_xyz[0])

    return volume, spacing_zyx


def volume_to_mesh(volume: np.ndarray, spacing_zyx, threshold: float):
    mask = volume > threshold

    if mask.sum() == 0:
        raise RuntimeError("Maska jest pusta. Zmień THRESHOLD_HU.")

    verts, faces, normals, values = measure.marching_cubes(
        mask.astype(np.uint8),
        level=0.5,
        spacing=spacing_zyx,
    )

    verts_xyz = verts[:, [2, 1, 0]]

    mesh = trimesh.Trimesh(vertices=verts_xyz, faces=faces, process=True)

    components = mesh.split(only_watertight=False)
    if components:
        mesh = max(components, key=lambda m: len(m.faces))

    # mesh = mesh.simplify_quadric_decimation(100_000)

    return mesh


def main():
    volume, spacing = load_dicom_series(DICOM_DIR)

    print("Volume shape [z, y, x]:", volume.shape)
    print("Spacing [z, y, x] mm:", spacing)
    print("Value range:", float(volume.min()), float(volume.max()))

    mesh = volume_to_mesh(volume, spacing, THRESHOLD_HU)
    mesh.export(OUT_OBJ)

    print(f"Zapisano: {OUT_OBJ}")
    print("Vertices:", len(mesh.vertices))
    print("Faces:", len(mesh.faces))


if __name__ == "__main__":
    main()