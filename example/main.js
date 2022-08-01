const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://github.com/Moukrea/puppeteer');
  await page.screenshot({path: '/home/puppeteer/Downloads/screen.jpg'});
  await browser.close();
})();