# XBrain Demo

This demo provides a working, dockerized version of xbrain.  This is an experimental Python 3.x workflow designed to be universally accessible and reproducible using Docker.

## Download the data

To run the workflow, please make sure the following files are available.  Please use the [download-data.ipynb](https://github.com/nerdslab/xbrain/blob/master/Demo/download-data.ipynb) to retrieve ilastik classifiers and additional sample and ground truth data.

Files downloaded with download-data.ipynb:
- V1_imgdata_gt.npy
- V2_imgdata_gt.npy
- V3_imgdata_gt.npy
- xbrain_test_set_2a.npy
- xbrain_vessel_seg_v7.ilp

This is the list of files needed to run the [xbrain-demo.ipynb](https://github.com/nerdslab/xbrain/blob/master/Demo/xbrain-demo.ipynb) notebook:
- ilastik classifier:  [TBD] ilastik_classifiers/<>.ilp
- xbrain algorithms:  demo/xbrain.py
- xbrain notebook:  demo/xbrain-demo.ipynb
- sample input file:  demo/xbrain_test_set_2a.npy
- Docker file:  Dockerfile

## Instructions

- Install Docker
- Build docker image located in the demo directory
- Launch jupyter notebook using sample command below (modify local directory)
- Run notebook and inspect output
- Vary parameters and input files and rerun

## Installing Docker

- Potential install for your system:

~~~
pip install docker
~~~

- For more information refer to: https://docs.docker.com/engine/installation/

## Sample Docker Commands

~~~
docker build -t xbrain:v1 .
~~~

- This will generate the docker image named 'xbrain:v1' with all of the dependencies needed to run the pipeline (roughly ~4.19GB)

~~~
docker run -it --rm -p 8888:8888 -v /Users/graywr1/code/xbrain-latest:/home/jovyan/work/ xbrain:v1
~~~

- This will create the docker container you will work in
- The command will prompt the user to open a indicated URL (juypter notebook hosted locally)

## Future work

We are researching additional algorithms and porting the optimization code and parallelization work to this repository.  We plan to back our demo with Boss, a large spatial data storage service.
