class PackageMethod {

	parse(json) {
		this.data = {
			protocols: [],
		};

		let methodList = extractList(json, 'dataset > methods > methodStep');
		let methodDataList = [];

		for (let i in methodList) {
			let methodData = {
				descriptions: [],
				protocols: []
			};

			// Extract description list starting from most nested possible location.
			let descriptions = extractList(methodList[i], 'description > section');
			if (descriptions.length == 0) descriptions = extractList(methodList[i], 'description');
			descriptions = [...descriptions, ...extractList(methodList[i], 'instrumentation')];

			let protocols = extractList(methodList[i], 'protocol');

			for (let j in descriptions) {
				methodData['descriptions'].push({
					title: extractString(descriptions[j], 'title'),
					paragraph: extractString(descriptions[j])
				});
			}

			// fill method's protocols
			for (let j in protocols) {
				methodData['protocols'].push({
					title: extractString(protocols[j], 'title'),
					name: extractString(protocols[j], 'creator > individualName > surName'),
					url: extractString(protocols[j], 'distribution > online > url')
				});
			}

			methodDataList.push(methodData);
		}
		this.data['protocols'] = methodDataList;
	}

	build(template) {
		let element = template.find('#content-class-methods');
		let methodList = this.data['protocols'];

		// fill method description table
		for (let i in methodList) {
			let descriptions = methodList[i]['descriptions'];
			let protocols = methodList[i]['protocols'];
			let description_html = [];
			let protocol_html = [];

			// fill method's description
			for (let j in descriptions) {
				let title = descriptions[j]['title'];

				description_html.push(`
					<div style="font-weight: normal">
						<strong>${ title ? title + '<br><br>' : '' }</strong>
						${ descriptions[j]['paragraph'] }
						<br><br>
					</div>
				`);
			}

			// fill method's protocols
			for (let j in protocols) {
				let protocol = protocols[j];
				protocol_html.push(`
					<table class="table">
						<tbody>
							${ makeTableRow([['th', 'col-2', 'Protocol:'        ], ['td', 'col-10', protocol['title']            ]]) }
							${ makeTableRow([['th', 'col-2', 'Author:'          ], ['td', 'col-10', protocol['name']             ]]) }
							${ makeTableRow([['th', 'col-2', 'Available Online:'], ['td', 'col-10', activateLink(protocol['url'])]]) }
						</tbody>
					</table>
				`);
			}

			let html = `
				<div class="section-title"> Protocol </div>
				<div class="ml-3">
					${ description_html.join('<hr>') }
				</div>
				<br>
				${ protocol_html.join('<hr>') }
			`;
			element.append(html);
		}
	}
}
