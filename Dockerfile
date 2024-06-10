FROM python:3.9-alpine3.13
LABEL mantainer="londonappdeveloper.com"

#Permette di non salvare l'output nel buffer
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt 
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

#Elimino le extra-dipendenze temporanee sull'immagine docker per rendere il file piu' leggero 
#Una best practice e' quella di non usare lo root user ma di crearne uno nuovo
# dopo l'if fi equivale ad un else nella condizione
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user