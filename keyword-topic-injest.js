const dotenv = require('dotenv');
const assert = require('assert');
const axios = require('axios');
const {MongoClient} = require("mongodb");
const nlp = require('compromise');

dotenv.config();

const API_KEY = process.env.NEWS_API_KEY;

mongoConnectInsertRelatedNewsCollections();

async function mongoConnectInsertRelatedNewsCollections() {
    const client = new MongoClient("mongodb://localhost:2717");

    try{
        await client.connect({ useNewUrlParser: true, useUnifiedTopology: true });
        const db = client.db("news-api-db");

        const Headlines = db.collection("headlines");

        const KeyWordsTopics = db.collection("newsapi-keywords-and-topics")

        const headlinesDocs = await Headlines.find({}).toArray();

        // function(err, docs) {
        //     assert.equal(err, null);
        //     console.log("Found the following records");
        // }

        var titleString

        headlinesDocs.forEach(doc => {
            titleString += doc.description + " "
        });

        nlpDoc = nlp(titleString)

        topicsJson = nlpDoc.people().json()

        await topicsJson.forEach(async topic => {
            console.log(topic.terms)

            // var newsApiUrl = 'https://newsapi.org/v2/everything?' +
            //     'q=' + topic.text + '&' +
            //     'apiKey=' + API_KEY;

            // const getNewsApi = async () => {
            //     try {
            //         return await axios.get(newsApiUrl)
            //     } catch (error) {
            //         console.error('Error:', error)
            //     }
            // }
        
            // response = await getNewsApi();

            // console.log(response)
            
            // await KeyWordsTopics.insertMany(response.data.articles)
            // .then(function(){ 
            //     console.log("Data inserted")  // Success 
            // }).catch(function(error){ 
            //     console.error('Error: ', error)   // Failure 
            // });
        })

    } catch(err) {
        console.error(`Unable to connect to mongodb: ${err}`);
    } finally {
        client.close();
    }
}