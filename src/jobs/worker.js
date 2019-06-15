const EmailService = require('../services/email.service');
const emailService = new EmailService()

let throng = require('throng');
let Queue = require("bull");


let REDIS_URL = process.env.REDIS_URL || "redis://127.0.0.1:6379";

let workers = process.env.WEB_CONCURRENCY || 2;

let maxJobsPerWorker = 50;

function start() {
  try {
    let emailQueue = new Queue('email-queue', REDIS_URL);

    emailQueue.process('sendEmail',maxJobsPerWorker, async (job) => { 
        const mail = job.data;          
        const response = await emailService.sendEmail(mail.email, mail.subject, mail.body);
        return { value: "This will be stored" };
    });

  } catch (error) {
      throw error;
  }
  
}

throng({ workers, start });
