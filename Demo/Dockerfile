FROM jupyter/scipy-notebook
RUN git clone https://github.com/jhuapl-boss/intern.git && cd intern && git checkout RemoteExtension && git pull && python3 setup.py install --user
RUN conda install --yes -c ilastik-forge ilastik-dependencies-no-solvers
RUN conda install --yes --force libgfortran
# RUN conda install --yes -c ilastik-forge ilastik-meta=1.3.0a2=0_g2c40eb6
# RUN conda install --yes --force libgfortran
RUN pip install mahotas
RUN conda install --yes --force scipy
RUN pip install ndparse
# docker build -t xbrain:v1 .
# docker run -it --rm -p 8888:8888 -v /Users/graywr1/code/xbrain-latest:/home/jovyan/work/ xbrain:v1

#RUN conda install --yes -c ilastik-forge ilastik-dependencies-no-solvers=1.3 ilastik-meta=1.3.0a2=0_g2c40eb6 ilastik-launch
