# Hack The Box - Soulmate

**Dificultad:** Easy  
**SO:** Linux  
**IP:** 10.10.11.86  
**Fecha de resolución:** 2025-09-10  

## Resumen
Máquina que combina enumeración web y análisis de servicios expuestos para obtener acceso inicial.  
Este repo documenta paso a paso el proceso de resolución.

---

## Estructura del repo
- `enumeration.md`: Escaneos y descubrimientos iniciales.
- `exploitation.md`: Detalles de los exploits y pasos para acceso.
- `post-exploitation.md`: Obtención de flags y limpieza.
- `loot/`: Archivos y credenciales encontradas.
- `scripts/`: Scripts y exploits usados.

# Full root-level system access — Informe

**Resumen breve**

Reporte en formato README que resume una cadena de explotación completa que resultó en acceso root mediante la explotación de un servicio Erlang después de lograr acceso inicial vía CrushFTP vulnerable.

---

## Tabla de contenidos

* [Resumen](#resumen)
* [Cadena de ataque (Attack Chain Summary)](#cadena-de-ataque-attack-chain-summary)
* [Detalles técnicos clave](#detalles-t%C3%A9cnicos-clave)
* [Cadena de vulnerabilidades](#cadena-de-vulnerabilidades)
* [Misconfiguraciones críticas de seguridad](#misconfiguraciones-cr%C3%ADticas-de-seguridad)
* [Herramientas y recursos usados](#herramientas-y-recursos-usados)
* [Bandera(s) obtenida(s)](#banderas-obtenidas)
* [Descargo de responsabilidad / Uso responsable](#descargo-de-responsabilidad--uso-responsable)

---

## Resumen

Este documento resume una intrusión donde, partiendo de enumeración y explotación de un servicio web (CrushFTP vulnerable), se logró subir un backdoor PHP, obtener acceso de usuario (`ben`) y escalar hasta ejecución de comandos con privilegios `root` aprovechando un servicio Erlang mal configurado.

---

## Cadena de ataque (Attack Chain Summary)

1. **Reconocimiento:** Escaneo de puertos y enumeración de servicios HTTP.
2. **Descubrimiento de subdominios:** FFUF identificó `ftp.soulmate.htb`.
3. **Identificación de servicio:** Análisis del código fuente reveló CrushFTP versión `11.W.657`.
4. **Explotación de vulnerabilidad:** Se aprovechó **CVE-2025-31161** para crear una cuenta administrativa.
5. **Subida de archivo:** Backdoor PHP cargado vía interfaz administrativa de CrushFTP.
6. **Acceso inicial:** Web shell con acceso `www-data`.
7. **Enumeración del sistema:** LinPEAS mostró servicios Erlang y puertos inusuales.
8. **Descubrimiento de credenciales:** Credenciales hardcodeadas encontradas en archivos de configuración Erlang.
9. **Acceso de usuario:** SSH como `ben`.
10. **Escalada de privilegios:** Explotación del servicio Erlang permitió ejecución de comandos como `root`.

---

## Detalles técnicos clave

* **Vulnerabilidad explotada:** CVE-2025-31161 — bypass de autenticación en CrushFTP `11.W.657`.
* **Ejecución remota / carga de archivos:** Subida de PHP en directorio web accesible.
* **Configuración expuesta:** Credenciales en texto plano dentro de archivos de configuración Erlang.
* **Servicio peligroso:** Servicio Erlang con funciones peligrosas habilitadas (por ejemplo `os:cmd/1`) corriendo con privilegios elevados.

---

## Cadena de vulnerabilidades

* **CVE-2025-31161:** Creación/escalada de cuenta administrativa en CrushFTP.
* **Subida insegura de archivos:** Directorio de subida permite ejecución de PHP.
* **Credenciales embebidas:** Hardcoded credentials en configuración.
* **Servicio privilegiado accesible:** Erlang SSH/service ejecutándose con privilegios `root`.

---

## Misconfiguraciones críticas de seguridad

* CrushFTP en versión vulnerable sin parches.
* Aplicación web permitiendo ejecución de PHP en directorios de subida.
* Credenciales almacenadas en texto plano en archivos de configuración.
* Servicio Erlang expuesto y ejecutándose con privilegios elevados, sin restricciones a funciones peligrosas.

---

## Herramientas y recursos usados

**Reconocimiento**

* `nmap` — escaneo de red y servicios
* `feroxbuster` — enumeración de directorios web
* `ffuf` — descubrimiento de subdominios

**Explotación**

* Exploit público de **CVE-2025-31161** (CrushFTP)
* `pwncat-cs` — handler de reverse shells / gestión de sesiones
* `LinPEAS` — script de enumeración para escalada de privilegios

**Técnicas manuales**

* Análisis de código fuente HTML para identificación de versión
* Análisis de archivos de configuración para descubrimiento de credenciales
* Uso de shell Erlang para ejecución de comandos con privilegios

**Referencias externas**

* Repositorio público del exploit CVE-2025-31161
* Documentación/técnicas de ejecución de comandos en Erlang
* Advisories de seguridad de CrushFTP

---

## Bandera(s) obtenida(s)

* ✅ **User flag:** recuperada vía SSH como `ben`.
* ✅ **Root flag:** recuperada mediante ejecución de comandos en shell Erlang con privilegios `root`.

---

## Descargo de responsabilidad / Uso responsable

Este documento tiene fines informativos y de auditoría de seguridad. La explotación de sistemas sin autorización es ilegal. Si este trabajo forma parte de una auditoría autorizada o pentest, asegúrate de contar con el alcance y los permisos adecuados, y reporta las vulnerabilidades al propietario del sistema para su corrección.

---



<img width="1359" height="734" alt="image" src="https://github.com/user-attachments/assets/01f61392-974b-4d2b-826d-1211cf000771" />
