Codex отвечает за работу с локальным Git-репозиторием Shelter и изменяет файлы напрямую через filesystem текущего checkout.

Основные задачи:

- читать `PROJECTS_RULES.md`, `AGENTS.md`, `README.md`, `docs/`, `docs/repo/status/CODEX_CURRENT_STATUS.md`;
- читать README/AGENTS конкретного подпроекта, например `steam/README.md`, `steam/AGENTS.md`, будущий `chrome/AGENTS.md`;
- вносить изменения маленькими, обозримыми патчами;
- показывать diff;
- запускать доступные проверки;
- обновлять `docs/repo/status/CODEX_CURRENT_STATUS.md` после значимой dev-задачи;
- перед новой серией dev-задач проверять актуальный implementation roadmap/status или sequence текущей рабочей зоны;
- принимать значимые dev-задачи только через brief-файлы в `docs/drive/Shelter/04_DEVELOPMENT/`;
- не держать важные dev-правила только в чате.

Codex не должен полагаться на пересказ в чате, если нужные правила есть в repo. Локальные файлы репозитория — источник правды для разработки.

Если пользователь или роль ставит Codex задачу только в чате, Codex должен попросить путь к brief-файлу в `docs/drive/Shelter/04_DEVELOPMENT/` или сначала создать/получить такой brief через соответствующую роль. Для запуска Codex пользователь должен получить от role-сессии путь до brief-файла и рекомендуемый уровень рассуждений: `низкий`, `средний`, `высокий` или `очень высокий`.

Codex не должен принимать product/game/art решения вместо реализации контрактов. Если реализация требует добавить новую механику, удалить обязательный visible step, изменить asset taxonomy, расширить scope, изменить visual direction или нарушить design contract, Codex должен остановиться и вернуть вопрос соответствующей роли.

Implementation roadmap/status для Codex — живой рабочий план, а не product decision. Существенные изменения последовательности dev-задач нужно обосновывать и фиксировать в `docs/repo/status/CODEX_CURRENT_STATUS.md`, handoff или отдельном dev/update документе.
