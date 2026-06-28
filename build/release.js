#!/usr/bin/env node
"use strict";

const { glob } = require ("glob");
const { sh, systemSync } = require ("shell-tools");

function main ()
{
	// version
	const
		name    = sh (`node -p "require('./package.json').name"`) .trim (),
		file    = glob .sync (`**/version.rb`) [0],
      current = sh (`cat`, file) .match (/VERSION\s*=\s*"(.*?)"/) [1];

	if (sh (`npm pkg get version | sed 's/"//g'`) .trim () === current)
		systemSync (`npm version patch --no-git-tag-version --force`);

	const
      updated = sh (`npm pkg get version | sed 's/"//g'`) .trim (),
      series  = updated .replace (/\.[^\.]+$/, "");

   systemSync (`sed -i "" -E "s|"${current}"|"${updated}"|g" ${file}`);
	systemSync (`sed -i "" -E "s|'~> [0-9.]+'|'~> ${series}'|g" ./README.md`);

	const version = sh (`npm pkg get version | sed 's/"//g'`) .trim ();

	console .log (`Current version ${current}`);
	console .log (`New version ${version}`);

	// commit
	systemSync (`git add -A`);
	systemSync (`git commit -am 'Published version ${version}'`);
	systemSync (`git push origin`);

	// tag
	systemSync (`git tag ${version}`);
	systemSync (`git push origin --tags`);

	// gem
   systemSync (`npm run build`);
   systemSync (`gem push ./*.gem`);
}

main ();
