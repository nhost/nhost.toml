import { Request, Response } from 'express'
import { gzipSync } from 'zlib';

export default (req: Request, res: Response) => {
    const body = "here is a body"
    res.setHeader('Content-Type', 'text/plain');
    res.setHeader('Content-Length', body.length);

    console.log(req.headers['accept-encoding'])
    if (req.headers['accept-encoding']?.includes('gzip')) {
        res.setHeader('Content-Encoding', 'gzip');
        let bodyCompressed = gzipSync(body)
        console.log('gzip', bodyCompressed)
        res.status(200).end(bodyCompressed)
    } else {
       console.log("no gzip")
       res.status(200).end(body)
    }
}
