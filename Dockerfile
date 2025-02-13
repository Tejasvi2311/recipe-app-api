FROM python:3.9-alpine3.13
LABEL maintainer="Tejasvi"

# Set environment variable to disable Python output buffering
ENV PYTHONUNBUFFERED 1

# Copy dependencies and application files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Set the working directory
WORKDIR /app

# Expose port 8000 (useful for web applications)
EXPOSE 8000

# Install dependencies inside a virtual environment
ARG DEV=false # default value for development 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp


# Create a non-root user for security
RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set the PATH to include the virtual environment
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user
