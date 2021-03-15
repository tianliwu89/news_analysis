const dotenv = require('dotenv');
const axios = require('axios');
const {MongoClient} = require("mongodb");

dotenv.config();

const API_KEY = process.env.NEWS_API_KEY;

var newsApiUrl = 'https://newsapi.org/v2/top-headlines?' +
        'country=us&' +
        'apiKey=' + API_KEY;

mongoConnectInsertNewsCollections();

async function mongoConnectInsertNewsCollections() {
    const client = new MongoClient("mongodb://localhost:2717");

    try{
        await client.connect({ useNewUrlParser: true, useUnifiedTopology: true });
        const db = client.db("news-api-db");

        const Headlines = db.collection("headlines");

        console.log(`Connected to database ${db.databaseName}`)

        const getNewsApi = async () => {
            try {
                return await axios.get(newsApiUrl)
            } catch (error) {
                console.error('Error:', error)
            }
        }

        response = await getNewsApi();
        console.log(response)
        await Headlines.insertMany(response.data.articles)
        .then(function(){ 
            console.log("Data inserted")  // Success 
        }).catch(function(error){ 
            console.error('Error: ', error)   // Failure 
        });

    } catch(err) {
        console.error(`Unable to connect to mongodb: ${err}`);
    } finally {
        client.close();
    }
}