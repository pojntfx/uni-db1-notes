# Uni DB1 Notes

Notes for the DB1 (databases) course at HdM Stuttgart. DB1 is an introduction to SQL and PL/SQL using the proprietary Oracle database.

If you intend on learning how to work with databases, please refrain from using the proprietary Oracle database. Choose a superior alternative, such as PostgreSQL or MariaDB instead. [Free Software, Free Society](https://www.fsf.org/about/what-is-free-software)!

[![Deliverance CI](https://github.com/pojntfx/uni-db1-notes/actions/workflows/deliverance.yaml/badge.svg)](https://github.com/pojntfx/uni-db1-notes/actions/workflows/deliverance.yaml)

## Overview

You can [view the notes on GitHub pages](https://pojntfx.github.io/uni-db1-notes/), [download them from GitHub releases](https://github.com/pojntfx/uni-db1-notes/releases/latest) or [check out the source on GitHub](https://github.com/pojntfx/uni-db1-notes).

## Contributing

To contribute, please use the [GitHub flow](https://guides.github.com/introduction/flow/) and follow our [Code of Conduct](./CODE_OF_CONDUCT.md).

To build and open a note locally, run the following:

```shell
$ git clone https://github.com/pojntfx/uni-db1-notes.git
$ cd uni-db1-notes
$ ./configure
$ make depend
$ make dev-pdf/your-note # Use Bash completion to list available targets
# In another terminal
$ make open-pdf/your-note # Use Bash completion to list available targets
```

The note should now be opened. Whenever you change a source file, it will automatically be re-compiled.

## License

Uni DB1 Notes (c) 2022 Felicitas Pojtinger and contributors

SPDX-License-Identifier: AGPL-3.0
