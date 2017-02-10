# Pull base image.
FROM ubuntu-node-elixir

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Add files.
# ADD root/.bashrc /root/.bashrc
ADD app2 /var/www/blog/app
ADD mix.exs /var/www/blog/mix.exs
ADD priv /var/www/blog/priv
ADD lib /var/www/blog/lib
ADD config /var/www/blog/config
ADD web /var/www/blog/web

# Install.
RUN \
  cd /var/www/blog/app && \
  npm install --yes && \
  npm install -g elm --yes && \
  npm install -g elm-css --yes && \
  elm package install --yes && \
  gulp build && \
  npm uninstall --yes && \
  npm uninstall -g gulp-cli --yes && \
  npm uninstall -g gulp --yes && \
  npm uninstall -g elm --yes && \
  npm uninstall -g elm-css --yes && \
  apt-get remove nodejs -y && \
  apt-get autoremove -y && \
  cd /var/www/blog && \
  mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix compile && \
  rm -rf /var/www/blog/app

WORKDIR /var/www/blog

# Define default command.
CMD ["mix", "phoenix.server"]