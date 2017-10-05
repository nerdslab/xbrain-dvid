xbrain demo readme
~~~~~~~~~~~~~~~~~~
Initial Version: W. Gray Roncal 10.4.2017

This demo provides a working, dockerized version of xbrain.
To run the workflow, please make sure the following files are available:

- ilastik classifier:  library/ilastik_classifiers/ilastik_test_s4.ilp
- xbrain algorithms:  demo/xbrain.py
- xbrain notebook:  demo/xbrain-demo.py
- sample input file:  demo/xbrain_test_set_2a.npy
- Docker file:  Dockerfile

## Instructions

- Install Docker
- Build docker image located in the demo directory
- Launch jupyter notebook using sample command below (modify local directory)
- Run notebook and inspect output

## Sample Docker Commands

~~~
docker build -t xbrain:v1 .
docker run -it --rm -p 8888:8888 -v /Users/graywr1/code/xbrain-latest:/home/jovyan/work/ xbrain:v1
~~~

## Goal 
https://github.com/evadyer/xbrain-py/blob/master/code/xbrain_ilastik_workflow_celldetect_vesselseg.ipynb
