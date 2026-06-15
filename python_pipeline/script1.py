import os
from pathlib import Path
import pydicom
import numpy as np
from skimage import measure
import trimesh

def load_scan(path):
    # loading all dicoms files for a patinet
    slices = [pydicom.dcmread(os.path.join(path, s)) for s in os.listdir(path) if s.endswith(".dcm")]
    # z axis sort
    slices.sort(key=lambda x: float(x.ImagePositionPatient[2]))
    # getting slice thickness and pixel spacing
    try:
        slice_thickness = np.abs(slices[0].ImagePositionPatient[2] - slices[1].ImagePositionPatient[2])
    except:
        slice_thickness = np.abs(slices[0].SliceLocation - slices[1].SliceLocation)
        
    for s in slices:
        s.SliceThickness = slice_thickness
        
    return slices
        
def get_pixels_hu(slices):
    # conversion to 3d numpy array
    image = np.stack([s.pixel_array for s in slices])
    image = image.astype(np.int16)
    
    # pixels out of field of view converted to to air, so -2000 changed to 0 or -1000
    image[image <= -1000] = 0
    
    #conversion to Hounsfield units
    for slice_number in range(len(slices)):
        intercept = slices[slice_number].RescaleIntercept
        slope = slices[slice_number].RescaleSlope
        
        if slope != 1:
            image[slice_number] = slope * image[slice_number].astype(np.float64)
            image[slice_number] = image[slice_number].astype(np.int16)
        image[slice_number] += np.int16(intercept)
        
    return np.array(image, dtype=np.int16)

def generate_mesh(dicom_folder, output_filename, threshold=400):
    print('loading dicom')
    patient_dicom = load_scan(dicom_folder)
    print(' conversion to Hounsfield units')
    patient_pixels = get_pixels_hu(patient_dicom)
    
    # pulling appropriate spacing to keep proportions
    spacing = map(float, ([patient_dicom[0].SliceThickness] + list(patient_dicom[0].PixelSpacing)))
    spacing = np.array(list(spacing))
    
    print(f'generating 3d mesh (marching cubes) for threshold {threshold} HU')
    verts, faces, normals, values = measure.marching_cubes(patient_pixels, level=threshold, spacing=spacing)
    print('obj file export')
    # trimesh is saving in file format usable in Godot
    mesh = trimesh.Trimesh(vertices=verts, faces=faces, vertex_normals=normals)
    mesh.export(output_filename)
    print(f'Saved file as {output_filename}')
        
    
MAIN_DIR = Path.cwd()
DICOM_DIR = MAIN_DIR / "data" / "raw_dicom"
EXAMPLE1_DIR = DICOM_DIR / "ID00422637202311677017371"
OUTPUT_FILE = MAIN_DIR / "data" / "output_models" /"model_cleaned_473.obj"

generate_mesh(EXAMPLE1_DIR, OUTPUT_FILE, threshold=300)