ARG appname=example
FROM python:3.11-bullseye AS base

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools uwsgi hatch

FROM base AS build

ADD . /staging

WORKDIR /staging

RUN python -m hatch test 
RUN python -m hatch build -t wheel

FROM base AS deploy

RUN mkdir -p /var/log/uwsgi

COPY --from=build /staging/dist/*.whl /tmp
COPY uwsgi.ini /etc/uwsgi/conf.d/uwsgi.ini

RUN python3 -m pip install /tmp/*.whl && rm -rf /tmp/*.whl

ENTRYPOINT [ "uwsgi", "--ini", "/etc/uwsgi/conf.d/uwsgi.ini" ]
