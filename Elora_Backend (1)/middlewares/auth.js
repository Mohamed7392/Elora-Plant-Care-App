module.exports = function(req, res, next) {
  // Simple auth middleware reading x-user-id from headers
  const userId = req.header('x-user-id');

  if (!userId) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  req.user = { id: userId };
  next();
};
