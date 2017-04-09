FROM python:2.7

MAINTAINER TYPO3 Documentation Team
LABEL Description="This image is used to render and deploy TYPO3 Documentation." Vendor="t3docs" Version="1.0"

# Install System dependencies
    RUN apt-get update && apt-get install -y \
        git \
        zip

# Install TYPO3 pip requirements
    RUN pip install Sphinx && \
        pip install pyyaml

# Install TYPO3 specific pip packages like theme.
    RUN pip install t3SphinxThemeRtd && \
        pip install t3fieldlisttable && \
        pip install t3tablerows && \
        pip install t3targets

# Setup environment
    WORKDIR /t3docs

    RUN git clone https://github.com/marble/TCT.git /t3docs/tct \
        && cd /t3docs/tct \
        && python setup.py install

    RUN mkdir /t3docs/resources \
        && git clone https://github.com/marble/typo3-docs-typo3-org-resources.git /t3docs/resources \
        && ln -s /t3docs/resources/check_include_files.py /usr/local/bin

    RUN mkdir /t3docs/toolchains \
        && git clone -b this-is-the-future https://github.com/marble/Toolchain_RenderDocumentation.git /t3docs/toolchains/RenderDocumentation

    COPY ["tctconfig.cfg", "/etc/tctconfig.cfg"]
    COPY ["makedir", "/t3docs/makedir"]

# Provide "interface" to outer world
    # ENTRYPOINT ["tct"]
    CMD [ \
        "tct" \
        ,"-v" \
        ,"run" \
        ,"RenderDocumentation" \
        ,"--config" \
        ,"talk" \
        ,"2" \
        ,"--config" \
        ,"rebuild_needed" \
        ,"1" \
        ,"--config" \
        ,"make_latex" \
        ,"0" \
        ,"--config" \
        ,"makedir" \
        ,"/t3docs/makedir" \
    ]

    # tct -v run RenderDocumentation --config talk 2 --config rebuild_needed 1 --config make_latex 0 --config makedir /t3docs/makedir
