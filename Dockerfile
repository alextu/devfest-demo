FROM alpine
COPY hello.sh /
RUN chmod +x hello.sh
CMD ["./hello.sh"]
