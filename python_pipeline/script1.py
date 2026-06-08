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
        
def get_pixels_hu(slices):
    # conversion to 3d numpy array
    image = np.stack([s.pixel_aray for s in slices])
    image = image.astype(np.int16)
    
    # pixels out of field of view converted to to air, so -2000 changed to 0 or -1000
    image[image <= -1000] = 0
    
    #conversion to Hounsfield units
    for slice_number in range(len(slices)):
        
    
MAIN_DIR = Path.cwd()
DICOM_DIR = MAIN_DIR / "data" / "raw_dicom"
EXAMPLE1_DIR = DICOM_DIR / "ID00419637202311204720264"
