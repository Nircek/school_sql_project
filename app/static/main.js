export function isSetsEqual(a, b) {
  a = new Set(a);
  b = new Set(b);
  return a.size === b.size && a.isSubsetOf(b);
}

export async function apiRequest(url, init) {
  const response = await fetch(url, init);
  if (!response.ok) {
    let message = await response.text();
    if (message === "") message = response.statusText;
    const re = /Traceback [\s\S]*?\n(\S[\s\S]*)/;
    const match = re.exec(message);
    if (match !== null) message = match[1];
    alert(message);
    throw new Error(`Error: ${response.status} ${message}`);
  }
  return response;
}

export async function getPrettyName(table, obj) {
  const prettierObj = {
    nauczyciel: () => `${obj.imie} ${obj.nazwisko}`,
    klasa: () => `${obj.nazwa}`,
    uczen: async () =>
      `${await getPrettyNameById("klasa", obj.klasa_id)} - ${obj.imie} ${
        obj.nazwisko
      }`,
    sala: () => `${obj.nazwa}`,
    semestr: () => `${obj.data_poczatku} -- ${obj.data_konca}`,
    zajecia: async () =>
      [
        await getPrettyNameById("semestr", obj.semestr_id),
        await getPrettyNameById("nauczyciel", obj.nauczyciel_id),
        await getPrettyNameById("klasa", obj.klasa_id),
        obj.dzien,
        obj.czas_rozp,
      ].join(" "),
    platnosc: async () =>
      `${await getPrettyNameById("klasa", obj.klasa_id)} ${obj.tytul}`,
  };
  if (table in prettierObj) return await prettierObj[table]();
  throw new Error(`No pretty name for table ${table}`);
}

export async function getPrettyNameByIdTable(table) {
  const response = await apiRequest(`/api/db/${table}`);
  return await response.json();
}

const getPrettyNameByIdCache = {};

export async function getPrettyNameById(table, id) {
  if (!(table in getPrettyNameByIdCache)) {
    getPrettyNameByIdCache[table] = getPrettyNameByIdTable(table);
  }
  let table_rows = await getPrettyNameByIdCache[table];
  console.log(table_rows);
  const find = (id) => table_rows.find((obj) => obj[`${table}_id`] == id);
  if (find(id) === undefined) {
    getPrettyNameByIdCache[table] = getPrettyNameByIdTable(table);
    table_rows = await getPrettyNameByIdCache[table];
  }
  const obj = find(id);
  return await getPrettyName(table, obj);
}

export class SQLTable {
  constructor(name, columns, index = null) {
    this.name = name;
    this.columns = columns;
    this.index = index === null ? `${name}_id` : index;
    this.tableElement = document.createElement("table");
    this.addElement = document.createElement("tr");
  }

  getId(row) {
    if (typeof this.index === "string") return row[this.index];
    return this.index.map((key) => row[key]);
  }

  async getRows() {
    const response = await apiRequest(`/api/db/${this.name}`);
    return await response.json();
  }

  async deleteRow(id) {
    try {
      await apiRequest(`/api/db/${this.name}/${id}`, { method: "DELETE" });
    } catch (e) {
      console.error(e);
    }
    await this.refresh();
  }

  async addRow(obj) {
    try {
      await apiRequest(`/api/db/${this.name}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(obj),
      });
    } catch (e) {
      console.error(e);
    }
    await this.refresh();
    this.addElement.querySelector("input:not([disabled])").focus();
  }

  createRefreshButton() {
    const button = document.createElement("button");
    button.textContent = "\u27f3";
    button.addEventListener("click", async () => await this.refresh());
    return button;
  }

  createDeleteButton(id) {
    const button = document.createElement("button");
    button.textContent = "\u2716";
    button.addEventListener("click", async () => await this.deleteRow(id));
    return button;
  }

  createAddButton() {
    const button = document.createElement("button");
    button.textContent = "\u2795";
    button.addEventListener("click", async () => await this.handleAdd());
    return button;
  }

  async handleAdd() {
    await this.addRow(this.prepareNewData());
  }

  prepareNewData() {
    const data = Array.from(this.addElement.querySelectorAll("input,select"))
      .filter((input) => input.disabled === false)
      .map((input) => input.value);
    return this.columns
      .filter((key, _) => key !== this.index)
      .reduce((acc, key, index) => {
        acc[key] = data[index];
        return acc;
      }, {});
  }

  generateHeader() {
    const thead = document.createElement("thead");
    const btn = document.createElement("th");
    btn.appendChild(this.createRefreshButton());
    thead.replaceChildren(
      ...this.columns.map((key) => {
        const th = document.createElement("th");
        th.textContent = key;
        return th;
      }),
      btn
    );
    return thead;
  }

  async generateBody(data) {
    const tbody = document.createElement("tbody");
    tbody.replaceChildren(
      ...(await this.generateDataRows(data)),
      await this.generateAddRow()
    );
    return tbody;
  }

  async generateDataRows(data) {
    return await Promise.all(
      data.map(async (row) => {
        const tr = document.createElement("tr");
        const btn = document.createElement("td");
        btn.appendChild(this.createDeleteButton(this.getId(row)));
        tr.replaceChildren(
          ...(await Promise.all(
            this.columns.map(
              async (col) => await this.generateTableCellElement(row, col)
            )
          )),
          btn
        );
        return tr;
      })
    );
  }

  async generateTableCellElement(row, col) {
    const td = document.createElement("td");
    if (
      !(
        (col !== this.index && col.endsWith("_id")) ||
        custom_fk_mapping[`${this.name}:${col}`] !== undefined
      )
    ) {
      td.textContent = row[col];
      td.addEventListener("click", (ev) => {
        if (ev.detail !== 2) return;
        const target = ev.target;
        const input = document.createElement("input");
        input.setAttribute("type", "text");
        input.value = target.textContent;
        input.addEventListener("keydown", async (ev) => {
          if (ev.key === "Enter") {
            await this.updateRow(this.getId(row), col, input.value);
            input.replaceWith(input.value);
            input.focus();
          }
        });
        target.replaceChildren(input);
      });
    } else {
      const table =
        custom_fk_mapping[`${this.name}:${col}`] || col.slice(0, -3);
      td.textContent = await getPrettyNameById(table, row[col]);
      td.addEventListener("click", async (ev) => {
        if (ev.detail !== 2) return;
        const target = ev.target;
        const input = await generateValuesElement(table, row[col]);
        input.addEventListener("change", async (ev) => {
          await this.updateRow(this.getId(row), col, input.value);
          input.replaceWith(await getPrettyNameById(table, input.value));
          input.focus();
        });
        target.replaceChildren(input);
      });
    }
    return td;
  }

  async updateRow(id, key, value) {
    await apiRequest(`/api/db/${this.name}/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ [key]: value }),
    });
    if (
      key === this.index ||
      (Array.isArray(this.index) && this.index.includes(key))
    ) {
      await this.refresh();
    }
  }

  async generateAddRow() {
    const btn = document.createElement("td");
    btn.appendChild(this.createAddButton());
    this.addElement.replaceChildren(
      ...(await Promise.all(
        this.columns.map(async (col) => {
          const td = document.createElement("td");
          if (
            !(
              (col !== this.index && col.endsWith("_id")) ||
              custom_fk_mapping[`${this.name}:${col}`] !== undefined
            )
          ) {
            const input = document.createElement("input");
            input.setAttribute("type", "text");
            if (col === this.index) input.disabled = true;
            input.addEventListener("keydown", (ev) => {
              if (ev.key === "Enter") this.handleAdd();
            });
            td.appendChild(input);
          } else {
            const table =
              custom_fk_mapping[`${this.name}:${col}`] || col.slice(0, -3);
            td.appendChild(await generateValuesElement(table));
          }
          return td;
        })
      )),
      btn
    );
    return this.addElement;
  }

  async refresh() {
    this.tableElement.replaceChildren();
    const data = await this.getRows();

    if (data.length !== 0 && !isSetsEqual(Object.keys(data[0]), this.columns)) {
      console.error("Columns mismatch");
      console.error(Object.keys(data[0]));
      console.error(this.columns);
    }

    this.tableElement.replaceChildren(
      this.generateHeader(),
      await this.generateBody(data)
    );
  }
}

export const table_to_columns = {
  nauczyciel: ["nauczyciel_id", "imie", "nazwisko"],
  klasa: ["klasa_id", "nazwa", "wychowawca"],
  uczen: ["uczen_id", "imie", "nazwisko", "klasa_id"],
  sala: ["sala_id", "nazwa"],
  semestr: ["semestr_id", "data_poczatku", "data_konca"],
  zajecia: [
    "zajecia_id",
    "sala_id",
    "klasa_id",
    "nauczyciel_id",
    "semestr_id",
    "dzien",
    "czas_rozp",
    "czas_konc",
  ],
  frekwencja: ["zajecia_id", "data", "uczen_id", "obecnosc"],
  ocena: ["ocena_id", "zajecia_id", "uczen_id", "ocena", "data", "komentarz"],
  platnosc: [
    "platnosc_id",
    "klasa_id",
    "tytul",
    "opis",
    "kwota",
    "termin",
    "kategoria",
  ],
  zaplata: ["platnosc_id", "uczen_id", "kwota"],
};

export const table_to_index = {
  nauczyciel: null,
  klasa: null,
  uczen: null,
  sala: null,
  semestr: null,
  zajecia: null,
  frekwencja: ["zajecia_id", "data", "uczen_id"],
  ocena: null,
  platnosc: null,
  zaplata: ["platnosc_id", "uczen_id"],
};

export const custom_fk_mapping = {
  "klasa:wychowawca": "nauczyciel",
};

export function generateTableOptions() {
  return Object.keys(table_to_columns).map(
    (table_name) => new Option(table_name, table_name)
  );
}

export async function generateValuesOptions(table) {
  let rows = await apiRequest(`/api/db/${table}`);
  rows = await rows.json();
  generateValuesOptionsCache[table] = await Promise.all(
    rows.map(
      async (obj) =>
        new Option(await getPrettyName(table, obj), obj[`${table}_id`])
    )
  );
  return generateValuesOptionsCache[table];
}

const generateValuesOptionsCache = {};
export async function generateValuesOptionsCached(table) {
  if (!(table in generateValuesOptionsCache)) {
    generateValuesOptionsCache[table] = generateValuesOptions(table);
  }
  return (await generateValuesOptionsCache[table]).map((e) =>
    e.cloneNode(true)
  );
}

export async function generateValuesElement(table, value) {
  const select = document.createElement("select");
  select.replaceChildren(...(await generateValuesOptionsCached(table)));
  if (value !== undefined) select.value = value;
  return select;
}
