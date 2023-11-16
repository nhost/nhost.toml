import { Request, Response } from 'express'
import { gzip } from 'zlib';

export default (req: Request, res: Response) => {
    const body = "here is a body"

    res.setHeader('Content-Type', 'text/plain')

    if (req.headers['accept-encoding']?.includes('gzip')) {
        res.setHeader('Content-Encoding', 'gzip');
        gzip(body, (_, result) => res.status(200).send(result))
    } else {
       res.status(200).send(body)
    }
}
