const db = require('../../data/db-config')

const checkSchemeId = async (req, res, next) => {
  try {
    const scheme = await db('schemes')
      .where({ scheme_id: req.params.scheme_id })
      .first()

    if (!scheme) {
      return res.status(404).json({
        message: `scheme_id ${req.params.scheme_id} id li şema bulunamadı`,
      })
    }

    next()
  } catch (error) {
    next(error)
  }
}

const validateScheme = (req, res, next) => {
  const { scheme_name } = req.body
  if (typeof scheme_name !== 'string' || !scheme_name.trim()) {
    return res.status(400).json({ message: 'Geçersiz scheme_name' })
  }
  next()
}

const validateStep = (req, res, next) => {
  const { instructions, step_number } = req.body
  if (typeof instructions !== 'string' || !instructions.trim() ||
      !Number.isInteger(step_number) || step_number < 1) {
    return res.status(400).json({ message: 'Hatalı step' })
  }
  next()
}

module.exports = { checkSchemeId, validateScheme, validateStep }
