# Docker-Python-C++-SSH
This repository offers a development environment for Python and C++ with Docker

## Getting started
Dockerfile  
```
docker run --runtime nvidia --rm -it skujirai/docker-python-cpp-ssh
```  
Docker Compose  
```
docker-compose up --build
```

## C++ Develop environment
- Compiler: g++ 7.5.0
- Libraries:
    - [Eigen](http://eigen.tuxfamily.org/)
    - [Boost](https://www.boost.org/)
    - [spdlog](https://github.com/gabime/spdlog)

## Options
- `PORT_SSH`: SSH port
- `PORT_NOTEBOOK`: Port number for jupyter notebook
- `NOTEBOOK_PASS`: Password to access jupyter notebook
