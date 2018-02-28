FROM jupyter/scipy-notebook
RUN git clone https://github.com/jhuapl-boss/intern.git && cd intern && git checkout RemoteExtension && git pull && python3 setup.py install --user
RUN conda install --yes -c ilastik-forge ilastik-dependencies-no-solvers=1.3.0a2=0_g2c40eb6
RUN conda install --yes --force libgfortran
RUN pip install mahotas
RUN pip install ndparse

#Re-install latest version of ilastik to allow viagra access.
#RUN conda install --yes -c ilastik-forge ilastik-dependencies-no-solvers

# docker build -t xbrain:v1 .
# docker run -it --rm -p 8888:8888 -v /Users/rodrilm2/Repositories/xbrain/xBrainClone/xbrain/Demo:/home/jovyan/work/ xbrain:v1
# RUN conda install --yes -c ilastik-forge ilastik-meta=1.3.0a2=0_g2c40eb6
