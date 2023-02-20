FROM postgres

RUN apt update && apt install -y awscli 

COPY entrypoint.sh .

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]