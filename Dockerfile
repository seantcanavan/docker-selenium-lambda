# First stage: build
FROM public.ecr.aws/lambda/python@sha256:c95e0a2af8bd2bb58e9de147305d30a6e8e598200ef4a2e9a06d14a4934fb204 as build

# Set the environment variable
#ENV TEST_ENV=$TEST_ENV


RUN dnf install -y unzip && \
    curl -Lo "/tmp/chromedriver-linux64.zip" "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chromedriver-linux64.zip" && \
    curl -Lo "/tmp/chrome-linux64.zip" "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chrome-linux64.zip" && \
    unzip /tmp/chromedriver-linux64.zip -d /opt/ && \
    unzip /tmp/chrome-linux64.zip -d /opt/

# Second stage: final image
FROM public.ecr.aws/lambda/python@sha256:c95e0a2af8bd2bb58e9de147305d30a6e8e598200ef4a2e9a06d14a4934fb204

# install dependencies
#RUN dnf install -y atk cups-libs gtk3 libXcomposite alsa-lib \
#    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
#    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
#    xorg-x11-xauth dbus-glib dbus-glib-devel nss mesa-libgbm

# install dependencies including pipenv
RUN dnf install -y \
    atk \
    cups-libs \
    gtk3 \
    libXcomposite \
    alsa-lib \
    libXcursor \
    libXdamage \
    libXext \
    libXi \
    libXrandr \
    libXScrnSaver \
    libXtst \
    pango \
    at-spi2-atk \
    libXt \
    xorg-x11-server-Xvfb \
    xorg-x11-xauth \
    dbus-glib \
    dbus-glib-devel \
    nss \
    mesa-libgbm \
    python3 \
    python3-pip

# setup pip
RUN pip install --upgrade pip
RUN pip install --no-cache-dir pipenv


# Setup python dependencies
# RUN pip install selenium==4.17.2
COPY Pipfile.lock ./
COPY Pipfile ./
RUN pipenv install --system --deploy

COPY --from=build /opt/chrome-linux64 /opt/chrome
COPY --from=build /opt/chromedriver-linux64 /opt/
COPY main.py ./

CMD [ "main.handler" ]
