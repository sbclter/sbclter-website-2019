class PackagePeople {

	parse(json) {
		this.data = {
			publisher: {},
			owners: [],
			contacts: {},
		};

		// Parse publishers
		let publishers = extractList(json, 'dataset > publisher');
		this.data['publishers'] = this.parsePeopleData(publishers);

		// Parse owners
		let owners = extractList(json, 'dataset > creator');
		this.data['owners'] = this.parsePeopleData(owners);

		// Parse contacts
		let contacts = extractList(json, 'dataset > contact');
		this.data['contacts'] = this.parsePeopleData(contacts);

		// Parse owners
		let associated = extractList(json, 'dataset > associatedParty');
		this.data['associated'] = this.parsePeopleData(associated);
	}

	build(template) {
		let element = template.find('#content-class-people');
		let contents = null;

		// fill publishers field
		contents = this.makePeopleTables(this.data['publishers']);
		element.find('#field-publishers').append(contents);

		// fill owners field
		contents = this.makePeopleTables(this.data['owners']);
		element.find('#field-owners').append(contents);

		// fill contacts field
		contents = this.makePeopleTables(this.data['contacts']);
		element.find('#field-contacts').append(contents);

		// fill associated parties field
		contents = this.makePeopleTables(this.data['associated']);
		element.find('#field-associated').append(contents);
	}


	// ----------------------- Private Functions -------------------------


	parsePeopleData(people) {
		let result = [];

		for (let i in people) {
			let person = people[i];
			let row = [];

			for (let key in person) {
				let value = person[key];

				if (typeof value === 'object') {
					if      (key === 'address')        value = parseAddress(value);
					else if (key === 'individualName') value = parseName(value, '%F %L');
					else if (key === 'phone')          value = extractString(value, '', [], '<br/>');
					else                               value = extractString(value, '', [], ', ');
				}

				key = camelToWords(key);
				switch (key) {
					case 'Organization Name':       key = 'Organization'; break;
					case 'Individual Name':         key = 'Individual'; break;
					case 'Electronic Mail Address': key = 'Email'; break;
					case '_id':                     key = 'ID'; break;
					case 'Online Url':              key = 'Website'; break;
					case 'Position Name':           key = 'Position'; break;
				}

				row.push([key, value]);
			}

			result.push(row);
		}

		return result;
	}

	makePeopleTables(people) {
		let contents = '';

		for (let i in people) {
			let person = people[i];
			let rows = '';

			for (let j in person) {

				// parse item information
				let key = person[j][0];
				let value = person[j][1];

				// activate any link
				if (typeof value === 'string') {
					if (value.startsWith('http')) value = activateLink(value);
					if (value.includes('@'))      value = activateLink(`mailto: ${ value }`, value);
				}

				rows += makeTableRow([['th', '', key], ['td', '', value]]);
			}

			contents += `
				<table class="table floatbox people-table">
					<tbody>
					${ rows }
					</tbody>
				</table>`;
		}

		return contents;
	}
}
