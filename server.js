require("dotenv").config();

const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// MySQL Connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect((err) => {
  if (err) {
    console.log("Database Connection Failed:", err);
    return;
  }
  console.log("MySQL Connected");
});

// ===============================
// Create Setup Panel
// ===============================
app.post("/api/setup-panel", (req, res) => {
  const {
    manpower_count,
    role_holder_categories,
    count_per_category,
    preparation_stage,
    preparation_booths,
    preparation_time_per_case,
    preparation_rounds,
    preparation_autoclose,
    no_of_evaluations,
    rounds,
    no_of_evaluators,
    evaluator_participant_mapping,
    time_per_evaluation_round,
    reminder,
    reminder_count,
    auto_submit,
  } = req.body;

  const sql = `
    INSERT INTO setup_panel (
      manpower_count,
      role_holder_categories,
      count_per_category,
      preparation_stage,
      preparation_booths,
      preparation_time_per_case,
      preparation_rounds,
      preparation_autoclose,
      no_of_evaluations,
      rounds,
      no_of_evaluators,
      evaluator_participant_mapping,
      time_per_evaluation_round,
      reminder,
      reminder_count,
      auto_submit
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const values = [
    manpower_count,
    role_holder_categories,
    count_per_category,
    preparation_stage,
    preparation_booths,
    preparation_time_per_case,
    preparation_rounds,
    preparation_autoclose,
    no_of_evaluations,
    rounds,
    no_of_evaluators,
    evaluator_participant_mapping,
    time_per_evaluation_round,
    reminder,
    reminder_count,
    auto_submit,
  ];

  db.query(sql, values, (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    res.json({
      success: true,
      message: "Setup Panel created successfully",
      id: result.insertId,
    });
  });
});

// ===============================
// Get Setup Panel
// ===============================
app.get("/api/setup-panel", (req, res) => {
  db.query("SELECT * FROM setup_panel", (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    res.json({
      success: true,
      data: result,
    });
  });
});

// ===============================
// Get Single Setup Panel
// ===============================
app.get("/api/setup-panel/:id", (req, res) => {
  db.query(
    "SELECT * FROM setup_panel WHERE id=?",
    [req.params.id],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          error: err.message,
        });
      }

      if (result.length === 0) {
        return res.status(404).json({
          success: false,
          message: "Record not found",
        });
      }

      res.json({
        success: true,
        data: result[0],
      });
    }
  );
});

// ===============================
// Update Setup Panel
// ===============================
app.put("/api/setup-panel/:id", (req, res) => {
  const {
    manpower_count,
    role_holder_categories,
    count_per_category,
    preparation_stage,
    preparation_booths,
    preparation_time_per_case,
    preparation_rounds,
    preparation_autoclose,
    no_of_evaluations,
    rounds,
    no_of_evaluators,
    evaluator_participant_mapping,
    time_per_evaluation_round,
    reminder,
    reminder_count,
    auto_submit,
  } = req.body;

  const sql = `
    UPDATE setup_panel SET
      manpower_count=?,
      role_holder_categories=?,
      count_per_category=?,
      preparation_stage=?,
      preparation_booths=?,
      preparation_time_per_case=?,
      preparation_rounds=?,
      preparation_autoclose=?,
      no_of_evaluations=?,
      rounds=?,
      no_of_evaluators=?,
      evaluator_participant_mapping=?,
      time_per_evaluation_round=?,
      reminder=?,
      reminder_count=?,
      auto_submit=?
    WHERE id=?
  `;

  db.query(
    sql,
    [
      manpower_count,
      role_holder_categories,
      count_per_category,
      preparation_stage,
      preparation_booths,
      preparation_time_per_case,
      preparation_rounds,
      preparation_autoclose,
      no_of_evaluations,
      rounds,
      no_of_evaluators,
      evaluator_participant_mapping,
      time_per_evaluation_round,
      reminder,
      reminder_count,
      auto_submit,
      req.params.id,
    ],
    (err) => {
      if (err) {
        return res.status(500).json({
          success: false,
          error: err.message,
        });
      }

      res.json({
        success: true,
        message: "Setup Panel updated successfully",
      });
    }
  );
});

// ===============================
// Delete Setup Panel
// ===============================
app.delete("/api/setup-panel/:id", (req, res) => {
  db.query(
    "DELETE FROM setup_panel WHERE id=?",
    [req.params.id],
    (err) => {
      if (err) {
        return res.status(500).json({
          success: false,
          error: err.message,
        });
      }

      res.json({
        success: true,
        message: "Setup Panel deleted successfully",
      });
    }
  );
});

// ===============================
// Server
// ===============================
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});