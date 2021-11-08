FROM quay.io/ebi-ait/ingest-base-images:python_3.7-alpine

RUN apk add  git 

RUN git clone https://github.com/ebi-ait/hca-ebi-dev-team.git
WORKDIR ./hca-ebi-dev-team/scripts/populate_ingest
RUN pip install -r requirements.txt