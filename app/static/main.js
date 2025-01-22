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
    const data = Array.from(this.addElement.querySelectorAll("input"))
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
      this.generateAddRow()
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
    td.textContent = row[col];
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
    // await this.refresh();
  }

  generateAddRow() {
    const btn = document.createElement("td");
    btn.appendChild(this.createAddButton());
    this.addElement.replaceChildren(
      ...this.columns.map((key) => {
        const td = document.createElement("td");
        const input = document.createElement("input");
        input.setAttribute("type", "text");
        if (key === this.index) input.disabled = true;
        input.addEventListener("keyup", (ev) => {
          if (ev.key === "Enter") this.handleAdd();
        });
        td.appendChild(input);
        return td;
      }),
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
  platnosc: null,
  zaplata: ["platnosc_id", "uczen_id"],
};

export function generateTableOptions() {
  return Object.keys(table_to_columns).map(
    (table_name) => new Option(table_name, table_name)
  );
}

export async function generateSemestrOptions() {
  let semestry = await apiRequest(`/api/db/semestr`);
  semestry = await semestry.json();
  return semestry.map(
    (obj) =>
      new Option(`${obj.data_poczatku} -- ${obj.data_konca}`, obj.semestr_id)
  );
}

export async function generateKlasaOptions() {
  let semestry = await apiRequest(`/api/db/klasa`);
  semestry = await semestry.json();
  return semestry.map((obj) => new Option(`${obj.nazwa}`, obj.klasa_id));
}
