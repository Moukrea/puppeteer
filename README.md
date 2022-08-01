# moukrea/puppeteer

Puppeteer Docker image to run Puppeteer scripts with ease.

This is based upon [official Puppeteer documentation related to Docker](https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker), with slight alterations for an improved ease of use.

This image is self-maintained through Github Actions. Everytime Puppeteer has a new release, a new image is built with the same release number as Puppeteer.

----

## Usage

To run a single script stored on you host machine, simply run the following command:

```docker
docker run -it \
    --cap-add=SYS_ADMIN moukrea/puppeteer \
    node -e "$(cat /path/to/my/script.js)"
```

----

### Downloading/Extracting files

Considering the following script as an example (which only takes a screenshot on google.com):

```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://google.com');
  await page.screenshot({path: '/home/puppeteer/Downloads/screen.jpg'});
  await browser.close();
})();
```

As we are saving the screenshot in `home/puppeteer/Downloads` (this path needs to exist within the container, which is the case here), and we want to get the screenshot outside of the container, we need to use `--volume|-v` argument, just like this:

```docker
docker run -it \
    -v "/home/${USER}/Downloads:/home/puppeteer/Downloads" \
    --cap-add=SYS_ADMIN \
    moukrea/puppeteer \
    node -e "$(cat /path/to/my/script.js)"
```

This will mount my host's `/home/${USER}/Downloads` directory within `/home/puppeteer/Downloads` in the container, allowing me to get the screenshot once the script is done.

----

### Running complex scripts with multiple files

To run scripts using multiple files, you need to mount your scripts directly within the container. For this, you have the `/app` directory, then the command to execute your script is slightly different as the executed script is already within the container:

```docker
docker run -it \
    -v "/path/to/your/scripts:/app" \
    -v "/home/${USER}/Downloads:/home/puppeteer/Downloads" \
    --cap-add=SYS_ADMIN \
    moukrea/puppeteer \
    /bin/bash -c "cd /app && node -e "\$(cat main.js)"
```