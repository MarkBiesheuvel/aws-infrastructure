'use strict'

const additional_headers = [
    {
        key: 'Strict-Transport-Security',
        value: 'max-age=31536000; includeSubDomains; preload'
    },
    {
        key: 'X-Content-Type-Options',
        value: 'nosniff'
    },
    {
        key: 'X-Frame-Options',
        value: 'DENY'
    },
    {
        key: 'X-XSS-Protection',
        value: '1; mode=block'
    }
]

const reductional_header = [
    "server",
    "via",
    "x-amz-cf-id",
    "x-amz-id-2",
    "x-amz-request-id",
    "x-amz-server-side-encryption",
    "x-cache"
]

exports.handler = (event, context, callback) => {

  const [record] = event.Records
  const {response} = record.cf

  // Remove headers we don't want to show to end users
  reductional_header.forEach(key => {
    delete response.headers[key]
  })

  // Add headers to improve security
  additional_headers.forEach(header => {
    const key = header.key.toLowerCase()
    response.headers[key] = [header]
  })

  // Proceed as normal
  callback(null, response)
}
