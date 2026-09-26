const db = require('../../data/db-config')

function find() {
  return db('schemes as sc')
    .leftJoin('steps as st', 'sc.scheme_id', 'st.scheme_id')
    .select('sc.scheme_id', 'sc.scheme_name')
    .count({ number_of_steps: 'st.step_id' })
    .groupBy('sc.scheme_id', 'sc.scheme_name')
    .orderBy('sc.scheme_id', 'asc')
}

async function findById(scheme_id) {
  const rows = await db('schemes as sc')
    .leftJoin('steps as st', 'sc.scheme_id', 'st.scheme_id')
    .select('sc.scheme_id', 'sc.scheme_name', 'st.step_id', 'st.step_number', 'st.instructions')
    .where('sc.scheme_id', scheme_id)
    .orderBy('st.step_number', 'asc')

  if (!rows.length) return undefined

  return {
    scheme_id: rows[0].scheme_id,
    scheme_name: rows[0].scheme_name,
    steps: rows.filter(row => row.step_id !== null).map(row => ({
      step_id: row.step_id,
      step_number: row.step_number,
      instructions: row.instructions,
    })),
  }
}

function findSteps(scheme_id) {
  return db('steps as st')
    .join('schemes as sc', 'st.scheme_id', 'sc.scheme_id')
    .select('st.step_id', 'st.step_number', 'st.instructions', 'sc.scheme_name')
    .where('st.scheme_id', scheme_id)
    .orderBy('st.step_number', 'asc')
}

async function add(scheme) {
  const [scheme_id] = await db('schemes').insert(scheme)
  return db('schemes').where({ scheme_id }).first()
}

async function addStep(scheme_id, step) {
  await db('steps').insert({ ...step, scheme_id })
  return findSteps(scheme_id)
}

module.exports = { find, findById, findSteps, add, addStep }
