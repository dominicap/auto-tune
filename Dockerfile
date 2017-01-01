FROM ruby:2.4

MAINTAINER Dominic Philip <domi.a.philip@gmail.com>

RUN apt-get update && apt-get -y install cmake
RUN mkdir temp && cd temp && curl http://taglib.org/releases/taglib-1.11.1.tar.gz > /temp/taglib.tar.gz
RUN cd /temp && tar -xzvf taglib*
RUN cd /temp/taglib* && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release . -DBUILD_SHARED_LIBS=ON
RUN cd /temp/taglib* && make && make install
RUN gem install taglib-ruby
RUN rm -rf /temp
RUN apt-get autoremove && apt-get clean

CMD ["/bin/bash"]
