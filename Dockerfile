FROM postgres:16.3

RUN apt update && apt install -y awscli 

COPY entrypoint.sh .

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]