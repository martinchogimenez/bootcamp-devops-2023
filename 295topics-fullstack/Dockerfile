FROM node:alpine
WORKDIR /backend
LABEL org.opencontainers.image.description="Práctica del bootcamp clase DOcker" \
      org.opencontainers.image.authors="Martín Gimenez"
ENV PORT 80
COPY ./package*.json ./backend
RUN npm install
COPY . /backend
EXPOSE 80
CMD ["npm", "start"]
