FROM python:3.9-slim-bullseye

RUN python3 -m venv /opt/venv

COPY requirements.txt .
RUN . /opt/venv/bin/activate && pip install -r requirements.txt



COPY controller.py .    

RUN apt-get update -y
RUN apt-get install curl -y
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl

CMD IP_ADDRESS=10.0.0.1
CMD sed "s/192.168.1.1/${IP_ADDRESS}/" webhook.yaml | kubectl apply -f -
CMD . /opt/venv/bin/activate && exec python controller.py
