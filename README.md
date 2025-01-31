# SharkTeam-onvzeto

A `CARLA_0.9.15` https://tiny.carla.org/carla-0-9-15-linux-on linken érhető el.
Ezt másolja a Dockerfile bele a konténerbe a Carla telepítéséhez.

# Kész image használata
Feltöltöttem a githubra egy általam már buildelt konténer imaget.

# Image építése a dockerfile-al
## Feltétlek:
- Linuxos rendszer
- Docker telepítve
- Videókártya integráló csomagok a dockerhez ha kell
    - Nvidia: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    - Intel: ??
    - AMD: ??
- A `Dockerfile` és a `CARLA_0.9.15` egy mappában

Ebben a mappában:

```
docker build -t konténer-neve .
```
Ez kb. 15 perc alatt megvan.

Futtatás:
```
docker run -it --rm --runtime=nvidia --gpus all --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" konténer-neve
```

`--rm` flag leállítás után automatikusan törli a konténert
`--runtime=nvidia` csak nvidia gpuval kell

## X server
A konténernek hozzá kell férni a host X serveréhez, hogy ablakokat jeleníthessen meg a hoston.
Legegyszerűbb az X server autentikációját kikapcsolni az `xhost +` paranccsal. Használat után erősen javasolt azt visszakapcsolni az `xhost -`
paranccsal.

Szebb megoldások:
https://stackoverflow.com/questions/40499412/how-to-view-gui-apps-from-inside-a-docker-container
http://wiki.ros.org/docker/Tutorials/GUI

## Windows
Windowson a docker desktop telepítéséhez:
https://www.docker.com/products/docker-desktop/

X server:
http://www.straightrunning.com/XmingNotes/

Ezeket még nem teszteltem de elméletileg ezekkel windowson is el kéne indulnia.

# Carla tippek
https://rocketloop.de/en/blog/carla-setup-remote-access/

A Carla server a konténerben a /home/CARLA_0.9.15 mappában `./CarlaUE.sh` futtatásával indítható.
Érdemes vagy a `-ResX=<Integer>` és `-ResY=<Integer>` flagekkel az ablak méretét viszonylag kicsire beállítani vagy amíg tölt kézzel kisebbre venni.
A minőség állítására a `quality-level=<Low/Epic>` használható.

## PythonAPI
A Carlahoz járó PythonAPI a pippel elérhető carla modullal használható. Ez csak bizonyos python verziókkal működik.
A konténer a Python3.7 verziót tartalmazza egy Symlinkkel a `/usr/bin/python` -ra. Így elvileg működnek a `PythonAPI/examples` példái (a konténerben nem teszteltem mindegyiket).

## Fun fact:
Induláskor a Carla server konténerben ALSA könyvtár hiányából adódó hibákat ad de nem tudom miért hiányolja mivel lokálisan futtatva nem játszik le hangot.
De ha valamikor valamiért hang kéne belőle a Dockerfile módosításával ez orvosolható.

# Fejlesztési lehetőségek
Lehet, hogy egy multi stage docker build csökkentheti a build időt.