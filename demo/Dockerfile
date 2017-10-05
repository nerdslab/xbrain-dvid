FROM jupyter/scipy-notebook
RUN conda install --yes -c ilastik-forge ilastik-dependencies-no-solvers=1.3 ilastik-meta ilastik-launch
RUN conda install --yes --force libgfortran
RUN pip install mahotas
RUN pip install ndparse
