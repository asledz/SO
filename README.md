# SO
Systemy operacyjne, MIMUW


## Zadanie 1 - DLC

Program kodujący enigmę

## Zadanie 2 - PIX

Niezaimplementowane

## Zadanie 3 

Syscall w MINIXIE - odzyskiwanie oryginalnego rodzica.

## Zadanie 4

Nieskończone - dawanie kudosów procesom, szeregowanie ich wg. kudosów

## Zadanie 5

Encryptowanie podłączonego dysku za pomocą klucza szyfrem cezara.

## Zadanie 6

## Uruchamianie MINIXa

Tworzenie obrazu:

```
qemu-img create -f qcow2 -o backing_file=minix_backup.img minix.img
```
Uruchomienie obrazu:

```
qemu-system-x86_64 -curses -drive file=minix.img -rtc base=localtime -net user -net nic,model=virtio -m 1024M
```

Do SSHowania:
```
qemu-system-x86_64 -curses -drive file=minix.img -rtc base=localtime -net user,hostfwd=tcp::10022-:22 -net nic,model=virtio -m 1024M
```

Z dodatkowym dyskiem:

```
qemu-system-x86_64 -curses -drive file=minix.img -rtc base=localtime -net user,hostfwd=tcp::10022-:22 -net nic,model=virtio -m 1024M -drive file=extra.img,format=raw,index=1,media=disk
```

## Pliki źródłowe

