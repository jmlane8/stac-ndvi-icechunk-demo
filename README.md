#  STAC → NDVI → Icechunk (Versioned Geospatial Data Pipeline)

README written with the help of ChatGPT-5. This project was created with the help of ChatGPT-5, Gemini and Copilot.

This project explores an end-to-end workflow for working with modern cloud-native geospatial data:

1. **Discover and load Sentinel-2 scenes from EarthSearch STAC**
2. **Stack STAC items into an analysis-ready data cube with `stackstac`**
3. **Compute NDVI over a bounding box in Pennsylvania**
4. **Learn Icechunk’s versioned array storage using a clean synthetic example**

This repository is part of my geospatial engineering portfolio. The goal is to demonstrate fluency with **STAC, Zarr, Icechunk, xarray, stackstac**, and cloud-native raster workflows.

---

## 📂 Project Structure

P2_stac_ndvi_icechunk/
│
├── notebooks/
│ ├── data
│ ├── icechunk_demo_repo
│ ├── 01_stac_explore.ipynb
│ ├── 02_sentinel_stac_ndvi.ipynb
│ └── 03_icechunk_demo.ipynb
│
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── README.md
└── data/ # (auto-created during NDVI or Icechunk runs)
---

# 1. Notebook: **01_stac_explore.ipynb**
### *Explore STAC and EarthSearch Sentinel-2 Collections*

This notebook introduces:

### 🔹 STAC basics  
- What is STAC  
- Items, Collections, Assets  
- Asset metadata (bands, projections, datatypes)

### 🔹 EarthSearch Catalog  
This project uses the **public, no-auth-required** STAC catalog:  
**`https://earth-search.aws.element84.com/v1`**

Two external tutorials are followed:

1. **STAC Spec Tutorial — Sentinel-2 on AWS**  
   https://stacspec.org/en/tutorials/access-sentinel-2-data-aws/

2. **Advanced Geo-Python – EarthSearch Tutorial**  
   https://hamedalemo.github.io/advanced-geo-python/lectures/earth_search_tutorial.html

### 🔹 What you do in this notebook
- Query the `sentinel-2-l2a` collection using `pystac-client`
- Explore assets and band naming (`red`, `nir`, `nir08`, etc.)
- Examine cloud cover, geometry, and metadata
- Visualize footprints and coverage
- Select a small spatiotemporal search region:
bbox = [-75.8, 39.7, -75.3, 40.2] # PA region, lat/lon

This notebook sets the stage for NDVI computation.

---

# 2. Notebook: **02_sentinel_stac_ndvi.ipynb**
### *Stack STAC → Compute NDVI → Save Clean Zarr Dataset*

This notebook performs the core Sentinel-2 processing.

### 🔹 Steps implemented

#### **1. Convert bbox to Web Mercator**
STAC assets are most easily warped with:
```python
pyproj.Transformer.from_crs("EPSG:4326", "EPSG:3857")
2. Stack data with stackstac

Key points:

Correct asset names: ["red", "nir"] or ["red", "nir08"]

Avoid using B04 / B08 (EarthSearch uses lowercase descriptive names)

stackstac.stack(...) produces a (time, band, y, x) data cube

3. Compute NDVI
red = da.sel(band="red")
nir = da.sel(band="nir")
ndvi = (nir - red) / (nir + red)
3. Notebook: 03_icechunk_demo.ipynb
Icechunk Tutorial Using a Clean Synthetic Dataset

Icechunk is a framework for efficient, versioned, deduplicated storage of chunked array data.
It integrates with xarray through to_icechunk().

I had difficulty writing my NDVI dataset, so this notebook uses a tiny synthetic xarray Dataset to focus on the Icechunk concepts without friction.

🔹 What this notebook covers
1. Create a dataset from random values
2. Create a local Icechunk repo
3. Write the dataset and commit snapshot v1
4. Modify the dataset and commit snapshot v2
5. Read old vs new versions
6. Compare or visualize changes


This project includes:

Dockerfile
Base image with Python, JupyterLab, stackstac, xarray, pystac-client, icechunk

docker-compose.yml
Launches a Jupyter Lab server on localhost:8888 with mounted notebooks and data.

Start the environment with:
```bash
docker compose up
```
Possible next steps:

Add geospatial Icechunk example using cleaned NDVI Zarr