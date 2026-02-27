

# EAFC Ratings

## 📱 Instrucciones para ejecutar la app 

Compilar y ejecutar el proyecto desde xcode.
_Version Xcode_: 26.1 _Minimum deployments_: iOS 18.6

## 🏗️ Arquitectura y Patrones de Diseño

Se ha implementado una arquitectura **Clean Architecture** combinada con **MVVM** y el patrón **Coordinator (Router)**, garantizando un desacoplamiento total entre las capas de datos, lógica de negocio y presentación.

* **Presentation Layer**: Vistas en SwiftUI. Uso de `ViewModels` aislados en `@MainActor` que contienen la lógica de la vista.
* **Domain Layer**: Contiene la lógica de negocio de la aplicación. Entidades puras (`Player`), protocolos de repositorio y Casos de Uso (`GetPlayersUseCase`) que dictan las reglas de negocio.
* **Data Layer**: Implementa la lógica de persistencia y red. Utiliza el patrón **Repository** para orquestar los datos entre fuentes locales y remotas.
* **DIFactoryContainer**: Un contenedor centralizado que maneja la inyección de dependencias y el "bootstrapping" de la aplicación sin librerías externas.

---

## 💾 Estrategia de Datos y Persistencia

 **Estrategia** "Cache-Aside" / "Offline-First"

1. **Intercepción de Búsqueda**: Si hay un query, se busca de forma local. Según especificaciones de la prueba. 
2. **Sincronización Silenciosa**: Se intentan obtener los datos de la red (try await remoteDataSource).
3. **Persistencia (Upsert)**: Si la red responde, se guardan los datos en local. Gracias al ID único, SwiftData actualizará si ya existen o insertará si son nuevos.
4. **Resiliencia (Fault Tolerance)**: Se utiliza un do-catch para manejar un fallo remoto. Si la red falla (error 500, modo avión), el error se "silencia" y el flujo continúa hacia la busquedad local.
5. **Fallback**: Al final, se devuelve lo que haya en local. Si la red falló, el usuario verá los datos de la última vez que tuvo conexión.


   Decidi usar esta estrategia debido a que esto garantiza que lo que el usuario ve en la pantalla es exactamente lo que está persistido. Si la app se cierra o se cae el Wi-Fi, la UI no miente porque siempre lee de la base de datos local (la única verdad).
---

## 🌐 Capa de Red (Networking)

Consumo del endpoint oficial de EA Sports.

* **Swift Concurrency**: Uso de `async/await` para todas las peticiones asíncronas, evitando bloqueos en el hilo principal.
* **Mappers**: Conversión de `DTOs` anidados del JSON hacia modelos planos de Dominio, aislando a la app de cambios en la estructura de la API.
* **Gestión de Paginación**: Cálculo dinámico de páginas basado en el `offset` solicitado por la interfaz de usuario.

---

## 📱 Interfaz de Usuario y UX

* **Manejo de Estados**: Gestión exhaustiva de estados: `Loading`, `Success`, `Empty` (para búsquedas sin resultados) y `Error` con opción de reintento.
* **Coordinadores**: Navegación desacoplada de las vistas. El `ViewModel` notifica la intención de navegar y un `Router` gestiona el `NavigationPath`.

---

## ⚡ Concurrencia y Swift 6

El proyecto está preparado para el modo de **Concurrencia Estricta** de Swift 6.

* **Actors**: `DataSources` y `Repositories` implementados como `actors` para garantizar la seguridad de memoria y evitar *data races*.
* **Sendable**: Todos los modelos que cruzan fronteras de actores (Domain, DTOs) conforman al protocolo `Sendable`.
* **Aislamiento de @MainActor**: Los ViewModels y Mocks de UI están correctamente aislados para interactuar con SwiftUI de forma segura.

---

## 🧪 Testing (Calidad de Código)

Suite de pruebas completa utilizando el nuevo framework **Swift Testing**.

* **BBDD Style (Given-When-Then)**: Tests estructurados para facilitar la lectura y comprensión de los casos de uso.
* **Actor-based Mocks**: Uso de mocks basados en actores para testear código asíncrono sin comprometer la seguridad de hilos.
* **Cobertura Crítica**: Se han testeado los flujos de carga inicial, paginación, búsqueda con *debounce* y navegación programática.

---

## 🛠️ A mejorar

**Creación de mappers**: Evolucionar de extensiones directas hacia objetos Mapper independientes permite una separación de responsabilidades (SRP) mucho más estricta, evitando el crecimiento excesivo de los modelos

**Implementación de logger**: para permitir transformar los fallos silenciosos en datos accionables, proporcionando visibilidad crítica sobre la salud de las peticiones remotas que, de otro modo, quedarían ocultas tras el mecanismo de fallback en el repositorio.

**Componentización de UI**: permite extraer elementos visuales recurrentes hacia piezas atómicas y configurables

**Implementación de una Base Screen genérica (o un StateContainer)**: crear una vista contenedor que orqueste los estados de forma global, con el objetivo de no tener que montar vistas comunes como loading / error / empty en todas las pantallas.
