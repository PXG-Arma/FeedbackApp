# n8n Automation Guide: Dashboard to Discord (With Data Summary)

This guide helps you set up a workflow that:
1.  Fetches the latest mission data (Score, Zeus, PL, etc.).
2.  Captures a screenshot of the dashboard.
3.  Sends a rich Discord message with both the stats and the image.

## Prerequisites
- **Target URL**: `https://pxg-arma.github.io/FeedbackApp/`
- **Data URL**: `https://www.pxghub.com/webhook/feedbackinfo`
- **Screenshot Service**: APIFlash (Access Key: `2e835243cfd243d895229f6dfac1482b`)
- **Discord Webhook**: Your channel URL.

---

## Step-by-Step Configuration

### 1. Trigger (Every Monday)
- Node: **Schedule Trigger** (Weekly, Mon 9:00).

### 2. Fetch Data (HTTP Request)
- Node: **HTTP Request**
- Method: `GET`
- URL: `https://www.pxghub.com/webhook/feedbackinfo`
- Authentication: None
- output: JSON

### 3. Process Data (Code)
- Node: **Code**
- Language: JavaScript
- **Code**:
  ```javascript
  // FIXED: Map n8n items to entries array
  const entries = items.map(item => item.json);

  function parseScore(val) {
      if (!val) return 0;
      return parseFloat(val) || 0;
  }

  function normalize(val) {
      return 5.0 - (2.0 * Math.abs(val - 3.0));
  }

  if (!entries || entries.length === 0) {
      return [{json: {opName: "No Data", date: "", count: 0, score: "N/A", zeus: "N/A", pl: "N/A"}}];
  }

  // Group by OpName + Date
  const missions = {};
  entries.forEach(e => {
      const key = e.OpName + '_' + e.Date;
      if (!missions[key]) missions[key] = [];
      missions[key].push(e);
  });

  const keys = Object.keys(missions);
  const latestMission = missions[keys[keys.length - 1]];

  // Initialize stats
  let totalFun = 0;
  let totalTech = 0;
  let totalCoord = 0;
  let totalPace = 0;
  let totalDiff = 0;

  let zeus = 'Unknown';
  let pl = 'Unknown';
  let opName = latestMission[0].OpName;
  let date = latestMission[0].Date;

  // Calculate totals
  latestMission.forEach(e => {
      totalFun += parseScore(e['Fun (1-5)']);
      totalTech += parseScore(e['Tech (1-5)']);
      totalCoord += parseScore(e['Coordination (1-5)'] || e['Coordination'] || 3);
      totalPace += parseScore(e['Pace (1-5)'] || e['Pace'] || 3);
      totalDiff += parseScore(e['Difficulty (1-5)'] || e['Difficulty'] || 3);

      if (e.Role === 'Zeus') zeus = e.player;
      if (e.Role === 'Platoon Leader' || e.Role === 'PL') pl = e.player;
  });

  const count = latestMission.length;
  const overallScore = (
      (totalFun/count) + 
      (totalTech/count) + 
      (totalCoord/count) + 
      normalize(totalPace/count) + 
      normalize(totalDiff/count)
  ) / 5.0;

  return [{
      json: {
          opName,
          date,
          count,
          score: overallScore.toFixed(1),
          zeus,
          pl
      }
  }];
  ```

### 4. Capture Screenshot (APIFlash)
- Node: **HTTP Request**
- URL: `https://api.apiflash.com/v1/urltoimage`
- Query Params:
  - `access_key`: `2e835243cfd243d895229f6dfac1482b`
  - `url`: `https://pxg-arma.github.io/FeedbackApp/`
  - `format`: `png`, `width`: `1920`, `height`: `1080`
  - `fresh`: `true`, `delay`: `5`
- **Response Format**: `File`
- **Binary Property**: `data`

### 5. Rename File (Code)
- Node: **Code**
- Code:
  ```javascript
  // Keep binary data, preserve JSON from "Process Data" node (optional, but good practice)
  // Actually, we just need to rename the current binary
  for (const item of items) {
      if (item.binary && item.binary.data) {
          item.binary.data.fileName = 'briefing.png';
      }
  }
  return items;
  ```

### 6. Send to Discord
- Node: **Discord**
- Message Type: **Embed**
- **Embeds**:
  - **Description**:
    ```text
    📊 **Weekly Intelligence Briefing**
    Here is the summary of the latest operation.

    **Mission:** {{ $('Process Data').first().json.opName }}
    **Date:** {{ $('Process Data').first().json.date }}

    ⭐ **Score:** {{ $('Process Data').first().json.score }}
    📝 **Responses:** {{ $('Process Data').first().json.count }}
    🌩️ **Zeus:** {{ $('Process Data').first().json.zeus }}
    🎯 **PL:** {{ $('Process Data').first().json.pl }}
    ```
  - **Color**: `#ff6b00` (Orange)
  - **Image URL**: `attachment://briefing.png`
- **Attachments**:
  - Field: `file`
  - Input: `data`
  - Name: `briefing.png`

---

## Complete JSON (Copy & Paste)

```json
{
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "weeks",
              "triggerAtDay": [
                1
              ],
              "triggerAtHour": 9
            }
          ]
        }
      },
      "id": "schedule-trigger",
      "name": "Every Monday",
      "type": "n8n-nodes-base.scheduleTrigger",
      "typeVersion": 1.1,
      "position": [
        380,
        340
      ]
    },
    {
      "parameters": {
        "url": "https://www.pxghub.com/webhook/feedbackinfo",
        "options": {}
      },
      "id": "fetch-data",
      "name": "Fetch Data",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [
        600,
        340
      ]
    },
    {
      "parameters": {
        "jsCode": "const entries = items.map(item => item.json);\n\nfunction parseScore(val) {\n    if (!val) return 0;\n    return parseFloat(val) || 0;\n}\n\nfunction normalize(val) {\n    // 3 is ideal (returns 5)\n    // 1 or 5 are poor (returns 1)\n    // Logic: 5.0 - (2.0 * |val - 3.0|)\n    return 5.0 - (2.0 * Math.abs(val - 3.0));\n}\n\nif (!entries || entries.length === 0) {\n    return [{json: {opName: \"No Data\", date: \"\", count: 0, score: \"N/A\", zeus: \"N/A\", pl: \"N/A\"}}];\n}\n\n// Group by OpName + Date\nconst missions = {};\nentries.forEach(e => {\n    const key = e.OpName + '_' + e.Date;\n    if (!missions[key]) missions[key] = [];\n    missions[key].push(e);\n});\n\n// Get latest mission\nconst keys = Object.keys(missions);\nconst latestKey = keys[keys.length - 1];\nconst latestMission = missions[latestKey];\n\n// Initialize stats\nlet totalFun = 0;\nlet totalTech = 0;\nlet totalCoord = 0;\nlet totalPace = 0;\nlet totalDiff = 0;\n\nlet zeus = 'Unknown';\nlet pl = 'Unknown';\nlet opName = latestMission[0].OpName;\nlet date = latestMission[0].Date;\n\n// Calculate totals\nlatestMission.forEach(e => {\n    totalFun += parseScore(e['Fun (1-5)']);\n    totalTech += parseScore(e['Tech (1-5)']);\n    totalCoord += parseScore(e['Coordination (1-5)'] || e['Coordination'] || e['Coord'] || 3);\n    totalPace += parseScore(e['Pace (1-5)'] || e['Pace'] || 3);\n    totalDiff += parseScore(e['Difficulty (1-5)'] || e['Difficulty'] || e['Dificulty'] || e['Diff'] || 3);\n\n    if (e.Role === 'Zeus') zeus = e.player;\n    if (e.Role === 'Platoon Leader' || e.Role === 'PL') pl = e.player;\n});\n\n// Calculate Averages\nconst count = latestMission.length;\nconst avgFun = totalFun / count;\nconst avgTech = totalTech / count;\nconst avgCoord = totalCoord / count;\nconst avgPace = totalPace / count;\nconst avgDiff = totalDiff / count;\n\n// Final Formula: (Fun + Tech + Coord + Norm(Pace) + Norm(Diff)) / 5\nconst overallScore = (avgFun + avgTech + avgCoord + normalize(avgPace) + normalize(avgDiff)) / 5.0;\n\nreturn [{\n    json: {\n        opName,\n        date,\n        count,\n        score: overallScore.toFixed(1),\n        zeus,\n        pl\n    }\n}];"
      },
      "id": "process-data",
      "name": "Process Data",
      "type": "n8n-nodes-base.code",
      "typeVersion": 1,
      "position": [
        820,
        340
      ]
    },
    {
      "parameters": {
        "url": "https://api.apiflash.com/v1/urltoimage",
        "responseFormat": "file",
        "dataPropertyName": "data",
        "sendQuery": true,
        "queryParameters": {
          "parameters": [
            {
              "name": "access_key",
              "value": "2e835243cfd243d895229f6dfac1482b"
            },
            {
              "name": "url",
              "value": "https://pxg-arma.github.io/FeedbackApp/"
            },
            {
              "name": "format",
              "value": "png"
            },
            {
              "name": "width",
              "value": "1920"
            },
            {
              "name": "height",
              "value": "1080"
            },
            {
              "name": "fresh",
              "value": "true"
            },
            {
              "name": "delay",
              "value": "5"
            }
          ]
        },
        "options": {}
      },
      "id": "apiflash-request",
      "name": "Capture Screenshot",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [
        1040,
        340
      ]
    },
    {
      "parameters": {
        "jsCode": "for (const item of items) {\n    if (item.binary && item.binary.data) {\n        item.binary.data.fileName = 'briefing.png';\n    }\n}\nreturn items;"
      },
      "id": "rename-file",
      "name": "Rename File",
      "type": "n8n-nodes-base.code",
      "typeVersion": 1,
      "position": [
        1260,
        340
      ]
    },
    {
      "parameters": {
        "webhookUri": "YOUR_DISCORD_WEBHOOK_URL_HERE",
        "options": {
          "embeds": {
            "values": [
              {
                "title": "PXG Intelligence Briefing",
                "description": "📊 **Weekly Intelligence Briefing**\nHere is the summary of the latest operation.\n\n**Mission:** {{ $('Process Data').first().json.opName }}\n**Date:** {{ $('Process Data').first().json.date }}\n\n⭐ **Score:** {{ $('Process Data').first().json.score }}\n📝 **Responses:** {{ $('Process Data').first().json.count }}\n🌩️ **Zeus:** {{ $('Process Data').first().json.zeus }}\n🎯 **PL:** {{ $('Process Data').first().json.pl }}",
                "color": "#ff6b00",
                "image": {
                  "url": "attachment://briefing.png"
                }
              }
            ]
          }
        },
        "attachments": [
          {
            "fieldName": "file",
            "fileName": "briefing.png",
            "binaryPropertyName": "data"
          }
        ]
      },
      "id": "send-discord",
      "name": "Send to Discord",
      "type": "n8n-nodes-base.discord",
      "typeVersion": 2,
      "position": [
        1480,
        340
      ]
    }
  ],
  "connections": {
    "Every Monday": {
      "main": [
        [
          {
            "node": "Fetch Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Fetch Data": {
      "main": [
        [
          {
            "node": "Process Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Process Data": {
      "main": [
        [
          {
            "node": "Capture Screenshot",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Capture Screenshot": {
      "main": [
        [
          {
            "node": "Rename File",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Rename File": {
      "main": [
        [
          {
            "node": "Send to Discord",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```
