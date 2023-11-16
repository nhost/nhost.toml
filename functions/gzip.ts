import { Request, Response } from 'express'
import { gzip } from 'zlib';
import { promisify } from 'util';

const gzipAsync = promisify(gzip);

export default (req: Request, res: Response) => {
    let body = "here is a body"

    res.setHeader('Content-Type', 'text/plain')

    if (req.headers['accept-encoding']?.includes('gzip')) {
        res.setHeader('Content-Encoding', 'gzip');
        try {
            body = await gzipAsync(body);
        } catch (error) {
            console.error('Error compressing body:', error);
        }
    }

    res.status(200).send(body)
}
