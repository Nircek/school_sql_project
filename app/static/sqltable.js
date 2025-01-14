function isSetsEqual(a, b) {
  a = new Set(a);
  b = new Set(b);
  return a.size === b.size && a.isSubsetOf(b);
}

class SQLTable {
  constructor(name, columns, index = null) {
    this.name = name;
    this.columns = columns;
    this.index = index === null ? `${name}_id` : index;
    this.tableElement = document.createElement("table");
    this.addElement = document.createElement("tr");
  }

  async getRows() {
    const response = await fetch(`/api/db/${this.name}`);
    return await response.json();
  }

  async deleteRow(id) {
    await fetch(`/api/db/${this.name}/${id}`, { method: "DELETE" });
    this.refresh();
  }

  async addRow(obj) {
    await fetch(`/api/db/${this.name}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(obj),
    });
    await this.refresh();
    this.addElement.querySelector("input:not([disabled])").focus();
  }

  createRefreshButton() {
    const button = document.createElement("button");
    button.textContent = "\u27f3";
    button.addEventListener("click", () => this.refresh());
    return button;
  }

  createDeleteButton(id) {
    const button = document.createElement("button");
    button.textContent = "\u2716";
    button.addEventListener("click", () => this.deleteRow(id));
    return button;
  }

  createAddButton() {
    const button = document.createElement("button");
    button.textContent = "\u2795";
    button.addEventListener("click", () => this.handleAdd());
    return button;
  }

  handleAdd() {
    this.addRow(this.prepareNewData());
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

  generateBody(data) {
    const tbody = document.createElement("tbody");
    tbody.replaceChildren(
      ...this.generateDataRows(data),
      this.generateAddRow()
    );
    return tbody;
  }

  generateDataRows(data) {
    return data.map((row) => {
      const tr = document.createElement("tr");
      const btn = document.createElement("td");
      btn.appendChild(this.createDeleteButton(row[this.index]));
      tr.replaceChildren(
        ...this.columns.map((key) => {
          const td = document.createElement("td");
          td.textContent = row[key];
          return td;
        }),
        btn
      );
      return tr;
    });
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
      this.generateBody(data)
    );
  }
}

const table_to_columns = {
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

const table_to_index = {
  nauczyciel: null,
  klasa: null,
  uczen: null,
  sala: null,
  semestr: null,
  zajecia: null,
  frekwencja: undefined,
  platnosc: null,
  zaplata: undefined,
};

function generateOptions() {
  return Object.keys(table_to_columns).map((table_name) => {
    const option = document.createElement("option");
    option.value = table_name;
    option.textContent = table_name;
    return option;
  });
}
