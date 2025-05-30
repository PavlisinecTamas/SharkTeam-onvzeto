# Kész image használata (egyszerűbb)
Feltöltöttem a githubra egy általam már buildelt konténer imaget.

```
docker pull ghcr.io/pavlisinectamas/onvezeto-image:latest
```

# Futtatás:
**Start script:**
```
./start.sh ghcr.io/pavlisinectamas/onvezeto-image 
```
- `-n` nvidia gpuval
- további argumentumok a dockernek lesznek átadva
  - pl.: `./start.sh konténer-neve -n --docker_opcio1`

Az általam feltöltött image esetén:
```
docker run -it --rm --runtime=nvidia --gpus all --device=/dev/dri:/dev/dri --env="DISPLAY=$DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/dev/dri:/dev/dri:rw" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ghcr.io/pavlisinectamas/onvezeto-image:latest

```
- `--rm` flag leállítás után automatikusan törli a konténert
- `--runtime=nvidia` csak nvidia gpuval kell

# Image építése a dockerfile-al
## Feltétlek:
- A `CARLA_0.9.15` https://tiny.carla.org/carla-0-9-15-linux linken érhető el.
  Ezt másolja a Dockerfile bele a konténerbe a Carla telepítéséhez.
  Letöltés után kb. 25 GB helyet foglal
- Docker telepítve
- Videókártya integráló csomagok a dockerhez ha kell
    - Nvidia: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    - Intel: Integált GPUnak nem kell 
    - AMD: ?? (https://rocm.docs.amd.com/en/docs-5.0.2/deploy/linux/quick_start.html)
- A `Dockerfile` és a `CARLA_0.9.15` egy mappában

Ebben a mappában:

```
docker build -t konténer-neve .
```
Ez kb. 15 perc alatt megvan.

Utánna futtatás ugyanúgy mint a letöltött image-el csak a konténer-neve taget használva.
> A bulidelést a docker cache készítésével segíti ez hamar hatalmasra nőhet.
>
> Törléshez: `docker builder prune`

## X server
A konténernek hozzá kell férni a host X serveréhez, hogy ablakokat jeleníthessen meg a hoston.
Legegyszerűbb az X server autentikációját kikapcsolni az `xhost +` paranccsal (a host parancssorában). 

Használat után erősen javasolt azt visszakapcsolni az `xhost -` paranccsal (a host parancssorában).

Mindez csak akkor szükséges ha valami miatt nem akarna egyből valami grafikus alkalmazás ablaka megjelenni.

Szebb megoldások:
https://stackoverflow.com/questions/40499412/how-to-view-gui-apps-from-inside-a-docker-container
http://wiki.ros.org/docker/Tutorials/GUI

## Windows
Windowson a docker desktop telepítéséhez:
https://www.docker.com/products/docker-desktop/

youtube tutorial:
https://www.youtube.com/watch?v=F-GFS6yRysU

# Carla tippek
https://rocketloop.de/en/blog/carla-setup-remote-access/

A Carla server a konténerben a /home/CARLA_0.9.15 mappában `./CarlaUE.sh` futtatásával indítható.
Érdemes vagy a `-ResX=<Integer>` és `-ResY=<Integer>` flagekkel az ablak méretét viszonylag kicsire beállítani vagy amíg tölt kézzel kisebbre venni.
A minőség állítására a `quality-level=<Low/Epic>` használható.

## PythonAPI
A Carlahoz járó PythonAPI a pippel elérhető carla modullal használható. Ez csak bizonyos python verziókkal működik.
A konténer a Python3.7 verziót tartalmazza egy Symlinkkel a `/usr/bin/python` -ra. Így elvileg működnek a `PythonAPI/examples` példái (a konténerben nem teszteltem mindegyiket).
