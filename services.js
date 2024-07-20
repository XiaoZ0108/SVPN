const { spawn, execSync } = require("child_process");
const fs = require("fs");
const scriptPath = "/home/ubuntu/openvpn-install.sh";

// Function to execute first script
const executeFirstScript = (name) => {
  return new Promise((resolve, reject) => {
    const scriptExecution = spawn("sudo", ["bash", scriptPath]);

    const answers = ["\n", "1\n", `${name}\n`]; // Ensure answers include newline characters

    // Write each answer with a delay
    let answerIndex = 0;
    const writeAnswer = () => {
      if (answerIndex < answers.length && !scriptExecution.stdin.destroyed) {
        scriptExecution.stdin.write(answers[answerIndex]);
        answerIndex++;
        setTimeout(writeAnswer, 200); // Adjust delay if necessary
      } else {
        scriptExecution.stdin.end(); // Close stdin after writing all answers
      }
    };

    // Start writing answers
    writeAnswer();

    scriptExecution.stdin.on("error", (err) => {
      console.error(`stdin error: ${err.message}`);
      reject(err);
    });

    scriptExecution.stdout.on("data", (data) => {
      console.log(`stdout: ${data}`);
    });

    scriptExecution.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });

    scriptExecution.on("close", (code) => {
      console.log(`First script exited with code ${code}`);
      resolve();
    });
  });
};

const generateAndReadScript = (name) => {
  executeFirstScript(name)
    .then(() => {
      console.log(
        "First script execution completed. Starting second script..."
      );
      return readOvpnFile(name);
    })
    .catch((err) => {
      console.error("Error:", err);
    });
};

function readOvpnFile(name) {
  const ovpnFilePath = `/root/${name}.ovpn`;
  try {
    // Use sudo to read the file contents as root
    const sudoCommand = `sudo cat ${ovpnFilePath}`;
    const fileContent = execSync(sudoCommand).toString();
    return fileContent;
  } catch (error) {
    throw new Error("Something went wrong");
  }
}
module.exports = { executeFirstScript, readOvpnFile };
