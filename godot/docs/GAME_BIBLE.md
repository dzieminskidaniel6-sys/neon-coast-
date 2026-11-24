# NEON COAST — GAME & STORY BIBLE
## The Lost Signal | Wersja 0.1 — fundament produkcyjny

> Dokument projektowy. Zawiera ustalony kierunek gry oraz propozycje fabularne rozwijające istniejący prototyp. Szczegóły oznaczone jako „do zatwierdzenia” nie są jeszcze kanonem.

---

## 1. Tożsamość gry

- **Tytuł:** NEON COAST
- **Podtytuł kampanii:** The Lost Signal
- **Gatunek:** single-player, third-person action-adventure, open-world
- **Ton:** zrównoważony — przygoda, humor, relacje, dramat i thriller kryminalny.
- **Struktura:** otwarty świat z kampanią główną, misjami pobocznymi i aktywnościami.
- **Docelowa długość:** 8–12 godzin kampanii głównej; dodatkowa zawartość wydłuża rozgrywkę.
- **Priorytet produkcyjny:** najpierw grywalność, fabuła, systemy i stabilność; oprawa wizualna na końcu.
- **Platforma prototypu:** Linux / Godot 4 / renderer Compatibility.
- **Ograniczenie sprzętowe:** projekt ma działać na Intel UHD 610 i 4 GB RAM. Budżet wydajności jest wymaganiem projektowym, nie obietnicą nieprzetestowanego FPS.

### Filary doświadczenia

1. **Osobista historia:** gracz szuka brata, a nie ratuje abstrakcyjny świat.
2. **Miasto z charakterem:** dzielnice, mieszkańcy, lokalne problemy i małe historie.
3. **Wolność między misjami:** jazda, eksploracja, zakupy, garaż i aktywności.
4. **Decyzje z konsekwencjami:** wybory wpływają na relacje, dostępne zadania, stan miasta i finał.
5. **Czytelna, lekka technologia:** systemy mają być modułowe i możliwe do optymalizacji.

---

## 2. Kanon fabularny

Poniższe elementy pochodzą z istniejących plików `story.py` i `missions.py`:
- Protagonistą jest Alex.
- Jego brat Leo zaginął trzy tygodnie przed rozpoczęciem historii.
- Akcja dzieje się w Vice District.
- Maya kieruje Alexa do mechanika Nico.
- Śledztwo prowadzi przez tracker samochodu, technika, informatorkę Vesper, nadajnik i starą stację przekaźnikową.
- Wątek prowadzi do niejawnych transportów i dokumentów Harbor Authority.
- Alex zdobywa klucz, przepustkę i przygotowuje się do wejścia na teren portu.
- Finał prowadzi do odnalezienia Leo, ujawnienia dowodów i odblokowania swobodnej eksploracji.

To jest rdzeń, którego nie usuwamy. Rozwijamy go o wybory i więcej grywalnych sytuacji.

## 3. Świat

### Vice District

Fikcyjne nadmorskie miasto inspirowane amerykańskimi miastami portowymi. Nie jest kopią prawdziwego miasta. Łączy turystyczne wybrzeże, starsze dzielnice, przemysłowy port i nowe inwestycje.

### Dzielnice docelowe

1. **Boardwalk** — promenada, diner, plaża, marina i początkowa baza kontaktów.
2. **Old Quarter** — starsze kamienice, małe sklepy, warsztaty i mieszkania.
3. **Downtown** — biura, wieżowce, hotele, parkingi i siedziby firm.
4. **Night Market** — targowisko, kluby, uliczne jedzenie i kontakty Vesper.
5. **Industrial Belt** — magazyny, stacja przekaźnikowa, bocznice i warsztaty.
6. **Harbor Authority Port** — terminal kontenerowy, bramy, biura ochrony i stary loading bay.
7. **Canal / Outskirts** — kanały, punkty widokowe, drogi wylotowe i ukryte miejsca.

### Zasada budowania mapy

Każda dzielnica musi mieć:
- powód fabularny, by do niej wracać;
- co najmniej jedną aktywność poboczną;
- charakterystyczny punkt orientacyjny;
- skróty lub alternatywne drogi;
- kilka interakcji niezwiązanych bezpośrednio z kampanią.

Mapa będzie powstawać etapami. Nie tworzymy ogromnego pustego terenu tylko po to, by wyglądał na duży.

---

## 4. Postacie

### Alex — protagonista
Szuka Leo. Nie jest zawodowym gangsterem ani superbohaterem. Jego mocną stroną jest upór i umiejętność zdobywania zaufania. Gracz określa jego styl działania przez decyzje, nie przez wybór klasy postaci.

### Leo — zaginiony brat
Odkrył nieprawidłowości związane z transportami i dokumentacją Harbor Authority. Zostawił tropy: tracker, nadajnik, notatkę o niebieskiej latarni, klucz i sygnał GPS. Jego dokładny los jest główną tajemnicą kampanii.

### Maya — pierwsza sojuszniczka
Zna miasto i pomaga Alexowi dotrzeć do Nico. Jest odważna, konkretna i ma własne granice. **Proponowany rozwój:** jej wcześniejsza relacja z Leo i jeden przemilczany błąd będą ważne dla zaufania Alexa.

### Nico — mechanik
Naprawiał samochód Leo. Zapewnia dostęp do garażu, napraw i ulepszeń. Wnosi humor i przyziemny punkt widzenia. Nie jest wyłącznie sklepem z ulepszeniami — ma własne problemy i zobowiązania.

### Vesper — informatorka
Działa na Night Market. Handluje informacjami i zna ludzi z różnych stron konfliktu. Pomaga, ale zawsze ocenia ryzyko i cenę. Gracz może zbudować z nią relację opartą na zaufaniu albo transakcji.

### Harbor Authority — główna siła antagonistyczna
Organizacja zarządzająca portem i prywatną ochroną. Oficjalnie odpowiada za bezpieczeństwo i rozwój gospodarczy. Nielegalna część jej działalności ukrywa się w fałszywej dokumentacji i tajnych transportach.

### Proponowany antagonista: Adrian Vale
Wysoki rangą zarządca Harbor Authority, publicznie przedstawiający się jako pragmatyczny reformator. Nie uważa się za złoczyńcę; twierdzi, że kontrola i tajemnica są ceną stabilności miasta. Do zatwierdzenia przed pisaniem finalnych dialogów.

---

## 5. Oś kampanii — 20 misji / 5 rozdziałów

Istniejące nazwy misji i ich podstawowa kolejność są zachowane. Poniżej opisujemy ich funkcję fabularną i planowany gameplay.

### Rozdział I — A Stranger in Town
1. **A Stranger in Town** — spotkanie z Mayą przy dinerze; poznanie celu Alexa i pierwsza prośba.
2. **The First Package** — dostarczenie zamkniętej walizki do garażu Nico; tutorial jazdy/poruszania i interakcji.
3. **Old Engine, New Lies** — rozmowa o naprawie auta Leo i odkrycie trackera.
4. **Market After Dark** — odnalezienie technika i Vesper na Night Market; pierwsza decyzja dotycząca sposobu zdobycia informacji.

### Rozdział II — Ghost Frequency
5. **Static on the Line** — badanie starej stacji przekaźnikowej i aktywnego sygnału.
6. **The Wrong Address** — przeszukanie starego mieszkania; odnalezienie notatki o niebieskiej latarni.
7. **Debt Collectors** — dotarcie do mariny przed ludźmi szukającymi danych; wybór: negocjacja, ucieczka lub konfrontacja.
8. **A Friend in Need** — odzyskanie narzędzi Nico; misja pobocznie rozwija jego relację z Alexem.

### Rozdział III — Harbor Files
9. **Ghost Frequency** — zdobycie zaszyfrowanego nadajnika i zrozumienie, że sygnał zawiera klucz.
10. **The Harbor Files** — infiltracja składu dokumentów; alternatywne wejście: cicho, przez kontakt albo siłowo.
11. **No Safe Route** — dostarczenie kopii dowodów Mayi; wybór, komu powierzyć oryginał.
12. **Night Shift** — rozmowa z pracownikiem portu, który widział transport przypominający przewóz Leo.

### Rozdział IV — Port of No Return
13. **The Watcher** — odnalezienie obserwatora na dachu; można zdobyć jego zaufanie lub go przestraszyć.
14. **Deep Storage** — odkrycie ukrytego magazynu i kolejnego śladu.
15. **The Second Key** — przekazanie klucza Vesper; rozliczenie wcześniejszych przysług i długów.
16. **Port of No Return** — przygotowanie pojazdu i przepustki; wybór wsparcia przed wejściem do portu.

### Rozdział V — The Lost Signal
17. **Break the Chain** — uruchomienie zakłócacza i wyłączenie części monitoringu na ograniczony czas.
18. **The Last Witness** — odnalezienie świadka przy kanale; ostatnia szansa na poznanie położenia Leo.
19. **Brother's Trail** — podążanie za ostatnim sygnałem GPS; ujawnienie, że Leo zostawił wiadomość dla Alexa.
20. **The Lost Signal** — dotarcie do Leo, decyzja o losie dowodów i konfrontacja z Harbor Authority.

### Zasada misji

Każda misja powinna mieć:
- motywację postaci;
- cel widoczny dla gracza;
- co najmniej jedną aktywność, w której gracz sam wykonuje ważną czynność;
- przeszkodę lub zwrot;
- nagrodę;
- reakcję świata lub postaci po zakończeniu.

Nie robimy 20 zadań typu „idź do znacznika i wróć”. Misje mają mieszać eksplorację, jazdę, rozmowy, skradanie, pościgi, poszukiwanie wskazówek i decyzje.

---

## 6. Decyzje i zakończenia

### Struktura narracji

Stosujemy strukturę **rozgałęzienia i ponownego łączenia**:
- główna oś 20 misji zachowuje tempo i prowadzi do finału;
- ważne decyzje zmieniają sceny, sojuszników, dostęp do zadań i stan świata;
- część misji ma alternatywne rozwiązania;
- w finale wcześniejsze działania składają się na kilka zakończeń.

Dzięki temu wybory są widoczne, ale nie mnożymy osobnych kampanii tak mocno, że projekt staje się niemożliwy do ukończenia. To podejście jest zgodne z praktyką projektowania rozgałęzionych narracji: konsekwencje powinny być czytelne i wracać w późniejszych scenach, a nie wymagać osobnej wersji całej gry dla każdego kliknięcia. Źródła inspiracji: GDC, „All Choice No Consequence”; materiały o strukturze branching/foldback narrative.

### Trwałe zmienne fabularne

- **maya_trust** — zaufanie Mayi.
- **nico_trust** — zaufanie Nico.
- **vesper_debt** — poziom zobowiązań wobec Vesper.
- **evidence_strength** — jakość i kompletność dowodów.
- **public_support** — ile osób w mieście jest gotowych ujawnić prawdę.
- **leo_bond** — stan relacji Alexa z Leo, określany przez odkryte wiadomości i wcześniejsze wybory.

Wartości powinny zmieniać się tylko wtedy, gdy gracz podejmuje decyzję lub wykonuje działanie, które ma uzasadniony wpływ.

### Przykładowe wybory

1. **Technik na Night Market:** zapłacić, przekonać go przysługą czy zastraszyć. Wpływa na pieniądze, reputację i późniejszą dostępność kontaktu.
2. **Dowody z magazynu:** przekazać je Mayi, Vesper czy niezależnemu dziennikarzowi. Wpływa na bezpieczeństwo dowodów i publiczne poparcie.
3. **Świadek przy kanale:** ochronić świadka lub natychmiast śledzić transport. Jedna opcja daje wiarygodne zeznanie, druga może dać szybszy trop.
4. **Finał:** priorytetem jest ujawnienie dokumentów, bezpieczeństwo Leo, czy próba zabezpieczenia obu rzeczy.

### Proponowane zakończenia

**A. The City Knows — ujawnienie prawdy**
Alex zabezpiecza dowody i doprowadza do ich publikacji. Harbor Authority traci wpływy, ale miasto musi zmierzyć się z konsekwencjami. Wymaga wysokiego evidence_strength i public_support.

**B. Blood Before Truth — rodzina przede wszystkim**
Alex ratuje Leo, ale dowody nie trafiają do opinii publicznej. Bracia uciekają z portu, a organizacja nadal ma wpływy. Wymaga silnej więzi z Leo i wyboru ratunku ponad publikację.

**C. A Deal in the Dark — układ**
Alex negocjuje z częścią kierownictwa i zabezpiecza wolność Leo, ale część prawdy zostaje ukryta. Wymaga odpowiednich relacji i wysokiej jakości informacji; cena to kompromis moralny.

**D. No One Gets Away — gorzkie zwycięstwo**
Dowody wychodzą na jaw, ale Alex traci ważne wsparcie, a los Leo pozostaje niepewny. To wynik działań, które doprowadziły do ujawnienia prawdy kosztem relacji i bezpieczeństwa.

**E. The Signal Goes Silent — porażka**
Za mało dowodów i wsparcia, błędne decyzje oraz brak przygotowania pozwalają Harbor Authority zamknąć sprawę. Alex może uciec z miasta, ale nie rozwiązuje zaginięcia.

Zakończenia są propozycją projektową do dalszego dopracowania. Nie będą wybierane przez jeden magiczny punkt moralności — sprawdzi je kombinacja decyzji i przygotowania.

---

## 7. Systemy rozgrywki

### Sterowanie i kamera
- trzecioosobowa kamera;
- niezależny obrót kamery i kierunku ruchu;
- chodzenie, sprint, skok;
- interakcje kontekstowe;
- ustawienia czułości i odwrócenia osi.

### Samochody
- pojazdy cywilne w kilku klasach;
- wsiadanie i wysiadanie;
- prowadzenie z przyspieszaniem, hamowaniem i skrętem;
- uszkodzenia wizualne i wpływ na prowadzenie w ograniczonym zakresie;
- garaż Nico: naprawy, ulepszenia osiągów i wyglądu;
- ruch uliczny dodawany dopiero po stabilnym systemie jazdy gracza.

### NPC i relacje
- NPC fabularni z dialogami i stanem relacji;
- proste rutyny mieszkańców w ograniczonych obszarach;
- interakcje kontekstowe;
- system dialogów oparty o dane, nie osobny skrypt dla każdej rozmowy.

### Ekonomia
- pieniądze za misje i aktywności;
- wydatki na naprawy, pojazdy, ubrania i bezpieczne miejsce;
- nagrody nie mogą wymuszać grindu przed misjami głównymi;
- brak płatnych mikropłatności w projekcie single-player.

### Aktywności poboczne
- dostawy kurierskie;
- krótkie wyścigi i próby czasowe;
- odzyskiwanie części dla Nico;
- fotografia punktów miasta;
- pomoc mieszkańcom;
- odkrywanie wiadomości i znajdziek Leo;
- opcjonalne zadania Vesper i Mayi.

### Zapis i postęp
- automatyczny zapis po ważnych misjach;
- ręczny zapis w bezpiecznych punktach;
- zapis pozycji, pieniędzy, pojazdu, misji, relacji i zmiennych fabularnych;
- oddzielny profil ustawień.

---

## 8. UX i interfejs

- HUD pokazuje tylko istotne informacje: cel, gotówkę, stan pojazdu i kontekst interakcji.
- Mapa z ikonami misji, garażu, sklepów i aktywności.
- Dziennik misji: cel, kontekst i aktualny etap.
- Telefon Alexa jako diegetyczne menu kontaktów, wiadomości, mapy i zadań.
- Pauza: kontynuuj, mapa, dziennik, ustawienia, zapis, wyjście.
- Dialogi mają imię postaci i czytelne opcje odpowiedzi.
- Opcje dostępności: regulacja czułości, rozmiaru tekstu, głośności i remapowanie sterowania (do wdrożenia).

---

## 9. Architektura techniczna Godot

Proponowany podział modułów:
- `GameState` — stan kampanii, pieniądze i globalne zmienne.
- `MissionManager` — wymagania, etapy, ukończenie i nagrody.
- `DialogueManager` — dialogi, wybory i reakcje postaci.
- `RelationshipManager` — relacje i flagi zaufania.
- `SaveManager` — serializacja stanu.
- `VehicleController` — sterowanie pojazdami.
- `InteractionSystem` — interakcje w zasięgu i kontekstowe podpowiedzi.
- `WorldManager` — aktywne dzielnice i strumieniowanie obszarów.

Dane misji i dialogów powinny być przechowywane oddzielnie od logiki scen, np. w zasobach Godot lub plikach JSON. Nazwy zmiennych i identyfikatory muszą być stabilne, żeby zapis nie psuł się po zmianie tekstu.

### Reguły wydajności

- Renderer Compatibility.
- Niskie koszty materiałów i geometrii.
- Brak volumetric fog, SSAO, SSR i ciężkiego post-processingu.
- Cienie tylko wtedy, gdy testy potwierdzą sensowny koszt.
- Ograniczona liczba aktywnych NPC i pojazdów.
- Proste kolizje; dekoracje bez fizyki.
- Dzielnice dzielone na chunki i aktywowane według odległości.
- LOD i occlusion culling dopiero po profilowaniu.
- Budżety CPU/RAM/GPU mierzone na rzeczywistym laptopie użytkownika.

---

## 10. Plan produkcji

### Faza 0 — dokumentacja
- zatwierdzić kanon postaci i antagonistę;
- rozpisać wszystkie 20 misji na sceny, cele, przeszkody i nagrody;
- ustalić zmienne decyzji i zakończeń;
- przygotować mapę dzielnic.

### Faza 1 — fundament gry
- poprawny ruch i kamera;
- system interakcji;
- dialogi i wybory;
- dziennik misji;
- GameState i zapis.

### Faza 2 — pionowy wycinek
- kompletna misja od początku do końca;
- jeden NPC z dialogami i konsekwencją wyboru;
- mały fragment dzielnicy;
- zapis i wczytanie;
- test wydajności na laptopie.

### Faza 3 — systemy świata
- jazda i garaż;
- ekonomia;
- relacje;
- aktywności poboczne;
- podstawowe zachowania NPC.

### Faza 4 — kampania
- implementacja 20 misji;
- rozgałęzione rozwiązania;
- cztery/pięć zakończeń;
- testy ścieżek fabularnych.

### Faza 5 — stabilizacja
- testy zapisu i odtwarzania;
- testy wszystkich zakończeń;
- naprawa błędów i optymalizacja;
- kontrola długości i tempa kampanii.

### Faza 6 — oprawa końcowa
- finalne modele, animacje i materiały;
- oświetlenie, atmosfera, dźwięk i muzyka;
- dopracowanie UI;
- profilowanie po każdym większym dodatku.

---

## 11. Kryteria ukończenia

Gra nie jest gotowa, dopóki:
- wszystkie 20 misji można ukończyć od początku do końca;
- każda ważna decyzja ma widoczną konsekwencję;
- każde zakończenie można osiągnąć i przetestować;
- zapis i wczytanie zachowują wszystkie kluczowe flagi;
- jazda, interakcje, dialogi i misje działają stabilnie;
- gracz może kontynuować eksplorację po kampanii;
- wydajność została zmierzona na docelowym sprzęcie;
- nie ma błędów blokujących progres.

---

## 12. Otwarte decyzje do zatwierdzenia

1. Czy Alex i Leo są biologicznymi braćmi, czy przybranymi? Propozycja: biologiczni, z napiętą relacją po dawnym konflikcie.
2. Czy Adrian Vale jest głównym antagonistą? Propozycja: tak, ale nie jedyny winny.
3. Czy w grze ma być walka z użyciem broni? Propozycja: ograniczona, rzadka i podporządkowana fabule; nacisk na ucieczkę, skradanie i improwizację.
4. Czy Alex ma mieć własne mieszkanie jako bazę? Propozycja: tak, odblokowane po pierwszym rozdziale.
5. Czy kampania ma mieć polskie i angielskie teksty? Propozycja: polski i angielski od początku, z tekstami oddzielonymi od kodu.

---

## 13. Zasady produkcyjne projektu

- Nie dodajemy grafiki kosztem grywalności.
- Nie deklarujemy funkcji jako gotowych, jeśli istnieją tylko w dokumencie.
- Każdy system najpierw dostaje mały testowy prototyp.
- Każda misja musi być grywalna, a nie tylko opisana.
- Po każdej większej zmianie uruchamiamy projekt i sprawdzamy błędy.
- Stary prototyp 2D pozostaje zachowany jako archiwum pomysłów; głównym kierunkiem jest Godot 4 / 3D.
