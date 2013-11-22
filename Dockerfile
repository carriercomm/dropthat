FROM   ubuntu:precise

RUN apt-get update
RUN apt-get install -y curl language-pack-en build-essential libpcre3-dev zlib1g-dev \
					   libatomic-ops-dev libaio-dev python git

# the ADD command breaks the build cache: ADD build.py /usr/src/
RUN cd /usr/src && curl -O https://raw.github.com/cagerton/pugpug/master/pugpug.py && python ./build.py

RUN useradd -r -M -s /bin/nologin nginx
RUN bash -c "for i in {0..9} {a..z} {A..Z}; do mkdir -p /opt/openresty/nginx/uploads/\$i; done"
RUN chown -R nginx /opt/openresty/nginx/uploads

RUN rm              /opt/openresty/nginx/conf/nginx.conf
ADD chat.conf       /opt/openresty/nginx/conf/nginx.conf
ADD chat.lua        /opt/openresty/nginx/conf/
ADD start.sh        /opt/openresty/nginx/

ADD secureup.html   /opt/openresty/nginx/html/
ADD sjcl.js         /opt/openresty/nginx/html/
ADD qrcode.js       /opt/openresty/nginx/html/
ADD robots.txt      /opt/openresty/nginx/html/
ADD dropth.at.css   /opt/openresty/nginx/html/
ADD chat.js         /opt/openresty/nginx/html/

RUN chmod +x /opt/openresty/nginx/start.sh

CMD ["/opt/openresty/nginx/start.sh"]
